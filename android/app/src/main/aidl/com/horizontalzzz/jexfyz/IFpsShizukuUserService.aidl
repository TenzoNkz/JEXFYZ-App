package com.horizontalzzz.jexfyz;

import android.os.Bundle;

interface IFpsShizukuUserService {
    Bundle executeFpsOperation(int operation) = 2;
    void destroy() = 16777114;
    void exit() = 1;
}
