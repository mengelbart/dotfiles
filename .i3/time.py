#!/usr/bin/env python

from datetime import datetime
k13 = datetime(2019, 03, 31, 18).isocalendar()[1]
holy = (k13 - datetime.now().isocalendar()[1]) * 2 + 2 + 7
x = datetime(2019, 03, 31, 18, 00, 01) - datetime.now()
h, r = divmod(x.seconds, 3600)
m, s = divmod(r, 60)
print '{:02}-{:02}:{:02}:{:02}'.format(x.days - holy, h,m,s)
