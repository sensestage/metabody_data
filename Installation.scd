// dependencies:
// install the additional quarks:
Quarks.updateDirectory;

// update to the latest versions of the quarks that we need:
Quarks.update("JITLibExtensions");
Quarks.update("adclib");
Quarks.update( "SenseWorld DataNetwork" );

// install the quarks that we need:
Quarks.install( "SenseWorld DataNetwork" ); // (SWDataNetwork)
Quarks.install( "adclib" ); // (MFunc)
Quarks.install( "JITLibExtensions" ); // (addSpec for Ndefs)

// modality toolkit
"https://github.com/ModalityTeam/Modality-toolkit"; // (FuncChain2)

// Download the toolkit from:
/*
https://github.com/ModalityTeam/Modality-toolkit/archive/master.zip
*/
// Unpack the toolkit (doubleclick, or rightclick and choose unpack...)

// And copy the folder Modality to your Extensions folder.

// You can open the extensions folder with this little line of SC code
Platform.userAppSupportDir.openOS;
