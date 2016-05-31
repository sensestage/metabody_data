/*

  public static final int CLASSIFICATION_MODE = 0;
  public static final int REGRESSION_MODE = 1;
  public static final int TIMESERIES_MODE = 2;
  public static final int CLUSTER_MODE = 3;

  //Classifier Types
  public static final int ANBC = 0;
  public static final int ADABOOST = 1;
  public static final int DECISION_TREE = 2;
  public static final int GMM = 4;
  public static final int KNN = 5;
  public static final int MINDIST = 6;
  public static final int RANDOM_FORESTS = 7;
  public static final int SOFTMAX = 8;
  public static final int SVM = 9;

*/

GRT {
	var <targetOSC;
	var <>recvPort=6000;

	var <mode;
	var <classifier;

	var <dataSize;
	var <vectorSize;

	var <oscFuncs;
	var <oscActions;

	*new{ |address|
		^super.new.init( address );
	}

	init{ |target|
		targetOSC = target;
		oscActions = IdentityDictionary.new;
	}

	sendData{ |data|
		targetOSC.sendMsg( *([ "/Data" ] ++ ( data.keep(dataSize) )) );
	}

	setup{ |pipeLineMode, numInputs, numOutputs|
		mode = pipeLineMode;
		dataSize = numInputs;
		vectorSize = numOutputs;
		targetOSC.sendMsg( "/Setup", pipeLineMode, numInputs, numOutputs );
	}

	setTrainingLabel{ |label|
		targetOSC.sendMsg( "/TrainingClassLabel", label );
	}

	// for regression
	setTargetVector{ |vector|
		targetOSC.sendMsg( *(["/TargetVector"] ++ ( vector.keep(vectorSize) )) );
	}

	record { |onoff|
		targetOSC.sendMsg( "/Record", onoff.binaryValue );
	}

	train { |onoff|
		targetOSC.sendMsg( "/Train", onoff.binaryValue );
	}

	saveTrainingSet{ |filename|
		targetOSC.sendMsg( "/SaveTrainingDatasetToFile", filename );
	}

	loadTrainingSet{ |filename|
		targetOSC.sendMsg( "/LoadTrainingDatasetFromFile", filename );
	}

	clearTrainingSet{ |filename|
		targetOSC.sendMsg( "/ClearTrainingDataset", filename );
	}

	/*
	 @param int classifierType: this should be one of the classifier types (see the list of defined classifier types at the top of this class)
   @param boolean useScaling: if true, then the GRT will automatically scale your data
   @param boolean useNullRejection: if true, then the GRT will automatically try to reject new data that has a low probability
   @param double nullRejectionThreshold: this value controls the null rejection threshold. See http://www.nickgillian.com/wiki/pmwiki.php/GRT/AutomaticGestureSpotting for more information.
   @return returns true if the setClassifier message was sent successful, false otherwise
  */
	setClassifier{ |classifierType, useScaling = false, useNullRejection = false, nullRejectionThreshold = 0|
		// if( classifierType < ANBC || classifierType > SVM ) return false;
		// if( nullRejectionThreshold < 0 ) return false;
		targetOSC.sendMsg( "/SetClassifier", classifierType, useScaling.binaryValue, useNullRejection, nullRejectionThreshold  );
	}

	initOSCFuncs{
		oscFuncs = [ "/Status", "/PreProcessedData" , "/FeatureExtractionData" , "/Prediction",
			"/ClassLikelihoods", "/ClassDistances", "/ClassLabels", "/RegressionData" ].collect{ |it|
			var id = it.drop(1).asSymbol;
			if ( oscActions.at( id ).isNil ){
				oscActions.put( id, MFunc.new );
			};
			OSCFunc.new( { |msg|
				oscActions.at( id ).value( msg.copyToEnd(1) );
			}, it, recvPort: this.recvPort );
		};
	}

	freeOSCFuncs {
		oscFuncs.do{ |it| it.free };
	}

}