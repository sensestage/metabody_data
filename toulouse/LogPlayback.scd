//Logplayback

/// files with the data:
(
~recordings = ( "".resolveRelative +/+ "video/logs/*/*.txt" ).pathMatch.sort;
~videos = ( "".resolveRelative +/+ "video/*.avi" ).pathMatch.sort;

// connection to video play:
~videoPlay = NetAddr.new( "127.0.0.1", 57152 );
OSCdef( \videoplay_started, { |msg| msg.postln }, "/videoplay/started", ~videoPlay );
OSCdef( \videoplay_quit, { |msg| msg.postln }, "/videoplay/quit", ~videoPlay );

// set up video play osc to send data for the frame number
OSCdef( \videorec_frame, { |msg| ~videoPlay.sendMsg( "/videoplay/frame", msg[1].asInteger ); }, "/videorec/frame" );
);

// go to start of video:
~videoPlay.sendMsg( "/videoplay/frame", 0 );

// open the file log:
// change index for different video:
("cd" + "".resolveRelative +/+ "video; videoplayosc" + ~videos[24] + NetAddr.langPort ).runInTerminal;
// change index for different recording:
~oscplayer = OSCFileLogPlayer( ~recordings[24], NetAddr.new( "127.0.0.1", NetAddr.langPort ) );


~processing = NetAddr.new( "127.0.0.1", 12000 );
OSCdef( \minibee2processing, { |msg| ~processing.sendMsg( *msg ) }, "/minibee/data" );
OSCdef( \minibee2processing ).free;

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


/// fill in the processing port where you want to have the data:
~oscforwarder = OSCForwarder.new( NetAddr.new( "127.0.0.1", 12001 ) );
// stop forwarding
~oscforwarder.stop;
// start forwarding againg
~oscforwarder.start;

// order:

// frontal camera
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

// overhead camera
14: duet 1 - camera IDS
15: duet 2 - camera IDS
16: duet 3 - camera IDS
17: duet 4 - camera IDS
18: duet 5 - camera IDS
19: duet 6 - camera JM
14: duet 6 - camera IDS
15: duet 7 - camera IDS
16: reference movements for orientations - camera IDS
17: duet 7 - camera IDS

// no camera data
18: pressure
