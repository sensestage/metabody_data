//x = x ? SWDataNetwork.new.createHost;
//x.makeGui;

("cd /home/nescivi/git/steim/metabody/toulouse/video/; videorecosc 1 Toulouse" ++ Date.localtime.stamp + NetAddr.langPort ).runInTerminal;

(
// initialisation:
~videoRec = NetAddr.new( "127.0.0.1", 57151 );
OSCdef( \videorec_started, { |msg| msg.postln }, "/videorec/started", ~videoRec );
OSCdef( \videorec_quit, { |msg| msg.postln }, "/videorec/quit", ~videoRec );
OSCdef( \videorec_record_off, { |msg| msg.postln }, "/videorec/record/stop", ~videoRec );
OSCdef( \videorec_record_on, { |msg| msg.postln; }, "/videorec/record/start", ~videoRec );
// OSCdef( \videorec_frame, { |msg| msg.postln; }, "/videorec/frame", ~videoRec );
);


~timelog = OSCFileLog.new( "".resolveRelative +/+ "video/logs/situations" ); ~videoRec.sendMsg( "/videorec/record", 1 );

~timelog.close;  ~videoRec.sendMsg( "/videorec/record", 0 );

// exit videorecosc
~videoRec.sendMsg( "/videorec/quit" );
