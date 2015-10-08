~baseKmap = KMap.new;
(
~baseKmap.addSpec( \x, [ 0.44, 0.56 ].asSpec );
~baseKmap.addSpec( \dx, [ 0.001, 0.1, \exp ].asSpec );
~baseKmap.addSpec( \y, [ 0.44, 0.56 ].asSpec );
~baseKmap.addSpec( \dy, [ 0.001, 0.1, \exp ].asSpec );
~baseKmap.addSpec( \z, [ 0.44, 0.56 ].asSpec );
~baseKmap.addSpec( \dz, [ 0.001, 0.1, \exp ].asSpec );
~baseKmap.addSpec( \mx, [ 0.44, 0.56 ].asSpec );
~baseKmap.addSpec( \my, [ 0.44, 0.56 ].asSpec );
~baseKmap.addSpec( \mz, [ 0.44, 0.56 ].asSpec );
);
