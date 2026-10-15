package com.horizontalzzz.jexfyz

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import com.flyfishxu.kadb.cert.KadbCert
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.DataInputStream
import java.io.DataOutputStream
import java.io.File
import java.io.FileOutputStream
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Persists the ADB host identity as AES-GCM ciphertext protected by Android Keystore.
 * The raw RSA private key and certificate are never written unencrypted to disk or backed up.
 * A corrupt/unreadable existing identity fails closed rather than silently rotating the ADB key.
 */
internal object WirelessAdbIdentityStore {
    private const val KEY_ALIAS = "je_cooler_wireless_adb_identity_v1"
    private const val FILE_NAME = "identity-v1.enc"
    private const val AAD = "com.horizontalzzz.jexfyz:wireless-adb-identity:v1"
    private const val HEADER = "JADB1"
    private const val IV_SIZE = 12
    private const val TAG_BITS = 128
    private const val MAX_IDENTITY_FIELD = 32 * 1024
    private const val TEN_YEARS_MS = 10L * 365L * 24L * 60L * 60L * 1000L
    private val lock = Any()

    /**
     * Load the existing identity into Kadb, or create/persist one only on first use.
     * Call before every pairing or ADB connection; KadbCert is process-global.
     */
    fun ensureLoaded(context: Context) = synchronized(lock) {
        val file = identityFile(context)
        if (file.exists()) {
            val stored = file.readBytes()
            val clear = decrypt(stored)
            try {
                val input = DataInputStream(ByteArrayInputStream(clear))
                val certificate = readBounded(input, "certificate")
                val privateKey = readBounded(input, "private key")
                check(input.available() == 0) { "Stored ADB identity has trailing data" }
                KadbCert.set(certificate, privateKey)
            } finally {
                clear.fill(0)
                stored.fill(0)
            }
        } else {
            val identity = KadbCert.get(notAfter = System.currentTimeMillis() + TEN_YEARS_MS)
            val clear = encode(identity.first, identity.second)
            try {
                writeAtomically(file, encrypt(clear))
            } finally {
                clear.fill(0)
            }
        }
    }

    private fun identityFile(context: Context): File {
        val directory = File(context.noBackupFilesDir, "wireless-adb")
        check(directory.exists() || directory.mkdirs()) { "Could not create private ADB identity directory" }
        return File(directory, FILE_NAME)
    }

    private fun encode(certificate: ByteArray, privateKey: ByteArray): ByteArray {
        require(certificate.isNotEmpty() && certificate.size <= MAX_IDENTITY_FIELD)
        require(privateKey.isNotEmpty() && privateKey.size <= MAX_IDENTITY_FIELD)
        val buffer = ByteArrayOutputStream()
        DataOutputStream(buffer).use { output ->
            output.writeInt(certificate.size)
            output.write(certificate)
            output.writeInt(privateKey.size)
            output.write(privateKey)
        }
        return buffer.toByteArray()
    }

    private fun readBounded(input: DataInputStream, field: String): ByteArray {
        val size = input.readInt()
        require(size in 1..MAX_IDENTITY_FIELD) { "Stored ADB $field length is invalid" }
        return ByteArray(size).also(input::readFully)
    }

    private fun encrypt(clear: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, getOrCreateKey())
        cipher.updateAAD(AAD.toByteArray(Charsets.UTF_8))
        val encrypted = cipher.doFinal(clear)
        val iv = cipher.iv
        check(iv.size == IV_SIZE) { "Android Keystore returned an unexpected AES-GCM IV size" }
        return ByteArrayOutputStream().use { buffer ->
            buffer.write(HEADER.toByteArray(Charsets.US_ASCII))
            buffer.write(iv)
            buffer.write(encrypted)
            buffer.toByteArray()
        }.also {
            encrypted.fill(0)
            iv.fill(0)
        }
    }

    private fun decrypt(stored: ByteArray): ByteArray {
        val header = HEADER.toByteArray(Charsets.US_ASCII)
        check(stored.size > header.size + IV_SIZE + 16) { "Encrypted ADB identity is truncated" }
        check(stored.copyOfRange(0, header.size).contentEquals(header)) {
            "Encrypted ADB identity format is not recognized"
        }
        val iv = stored.copyOfRange(header.size, header.size + IV_SIZE)
        val cipherText = stored.copyOfRange(header.size + IV_SIZE, stored.size)
        try {
            val cipher = Cipher.getInstance("AES/GCM/NoPadding")
            cipher.init(Cipher.DECRYPT_MODE, getOrCreateKey(), GCMParameterSpec(TAG_BITS, iv))
            cipher.updateAAD(AAD.toByteArray(Charsets.UTF_8))
            return cipher.doFinal(cipherText)
        } finally {
            iv.fill(0)
            cipherText.fill(0)
        }
    }

    private fun getOrCreateKey(): SecretKey {
        val store = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (store.getKey(KEY_ALIAS, null) as? SecretKey)?.let { return it }

        val generator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        generator.init(
            KeyGenParameterSpec.Builder(
                KEY_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build(),
        )
        return generator.generateKey()
    }

    private fun writeAtomically(file: File, encrypted: ByteArray) {
        val temporary = File(file.parentFile, "\${file.name}.tmp")
        try {
            FileOutputStream(temporary).use { output ->
                output.write(encrypted)
                output.fd.sync()
            }
            check(temporary.renameTo(file)) { "Could not atomically persist the encrypted ADB identity" }
        } finally {
            temporary.delete()
            encrypted.fill(0)
        }
    }
}
