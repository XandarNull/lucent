// SPDX-License-Identifier: GPL-2.0-or-later

#ifndef lucentopacity_h
#define lucentopacity_h

#include "lucentstyleconfigdata.h"

#include <QWidget>

namespace Lucent
{
//* opacity (0-100) to paint a translucent area of widget's window with:
//* fully opaque while the window is inactive, if OpaqueInactiveWindows is set
inline int effectiveOpacity(int opacity, const QWidget *widget)
{
    return StyleConfigData::opaqueInactiveWindows() && widget && !widget->isActiveWindow() ? 100 : opacity;
}
}

#endif
