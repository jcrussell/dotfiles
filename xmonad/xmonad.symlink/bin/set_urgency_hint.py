#! /usr/bin/env python

from Xlib import X, display, Xutil
import sys

def find_window(name, w):
  for win in w.query_tree().children:
    clazz = win.get_wm_class()
    if clazz and clazz[1] == name:
      hints = win.get_wm_hints()
      if hints and hints['flags'] & Xutil.IconPixmapHint:
        set_urgency(win)

    if len(win.query_tree().children) > 0:
      find_window(name, win)

def set_urgency(win):
  hints = win.get_wm_hints() or { 'flags': 0 }
  hints['flags'] |= Xutil.UrgencyHint

  win.set_wm_hints(hints)

def main(app, disp):
  find_window(app, disp.screen().root)
  disp.flush()

if __name__ == '__main__':
  if len(sys.argv) != 2:
    print "USAGE: %s <APP_NAME>" %(sys.argv[0])
    sys.exit(1)

  main(sys.argv[1], display.Display())
