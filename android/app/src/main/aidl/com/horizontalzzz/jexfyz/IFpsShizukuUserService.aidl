package com.horizontalzzz.jexfyz;

import android.os.Bundle;

interface IFpsShizukuUserService {
    Bundle executeFpsOperation(int operation);
    void destroy() = 16777114;
    void exit() = 1;
}
