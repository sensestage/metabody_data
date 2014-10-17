//Logplayback

/// files with the data:
(
~recordings = ( "".resolveRelative +/+ "video/logs/*/*.txt" ).pathMatch.sort;
~videos = ( "".resolveRelative +/+ "video/*.avi" ).pathMatch.sort;
);


(
// connection to video play:
~videoPlay = NetAddr.new( "127.0.0.1", 57152 );
OSCdef( \videoplay_started, { |msg| msg.postln }, "/videoplay/started", ~videoPlay );
OSCdef( \videoplay_quit, { |msg| msg.postln }, "/videoplay/quit", ~videoPlay );
);

(
// set up video play osc to send data for the frame number
OSCdef( \videorec_frame, { |msg| ~videoPlay.sendMsg( "/videoplay/frame", msg[1].asInteger ); }, "/videorec/frame" );
);

// go to start of video:
~videoPlay.sendMsg( "/videoplay/frame", 0 );

// open the file log:
// change index for different video:
("cd /home/nescivi/git/steim/metabody/toulouse/video/; videoplayosc" + ~videos[2] + NetAddr.langPort ).runInTerminal;
// change index for different recording:
~oscplayer = OSCFileLogPlayer( ~recordings[2], NetAddr.new( "127.0.0.1", NetAddr.langPort ) );


/// fill in the processing port where you want to have the data:
~oscforwarder = OSCForwarder.new( NetAddr.new( "127.0.0.1", 8000 ) );
// stop forwarding
~oscforwarder.stop;
// start forwarding againg
~oscforwarder.start;

// playback controls:
~oscplayer.play;

~oscplayer.pause;
~oscplayer.resume;
~oscplayer.stop;

~oscplayer.reset;

// quit video player
~videoPlay.sendMsg( "/videoplay/quit" );
// close oscplayer
~oscplayer.close;

OSCFunc.trace( false );

// order:

0 : Mario - heaviness
1 : Mario - run up
2 : Mario - run up
3 : Mario - blahblahblah
4 : Mario - blahblahblah
5 : Mario - contracted - extended
6 : Mario - fall

7 : Marianne - heaviness
8 : Marianne - heaviness
9 : Marianne - runup
10 : Marianne - blahblahblah
11 : Marianne - blahblahblah
12 : Marianne - contracted - extended
13 : Marianne - fall