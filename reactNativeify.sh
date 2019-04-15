#!/bin/bash

GREEN='\033[0;32m'    # Green Color
RED='\033[0;31m'      # Red Color
CYAN='\033[0;36m'     # Cyan Color
NC='\033[0m'          # No Color

projname=$1     # project name
projpath=$2      # project directory

lowercase=$(echo "$projname" | tr '[:upper:]' '[:lower:]') # converts to lower case

# Checks if project has name
detectProjName() {
  	if [ -z "$projname" ]
	then
	  	echo "${CYAN}Usage <sh reactProject.sh projectName projectPath>"
	  	exit
  	fi
}

# Checks if project has directory to be saved 
detectProjPath() {
  	if [ -z "$projpath" ] 
  	then
		echo "${CYAN}Usage <sh reactProject.sh projectName projectPath>"
		exit
  	fi
  	echo "${GREEN}Saving your project $projname in $projpath"
}

# Checks the user's Operating System
detectOS() {
  	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		linuxNode;
		installRN;
		linuxJDK;
		linuxAndroid;

  	elif [[ "$OSTYPE" == "darwin"* ]]; then
		osxNode;
		osxWatchman
		installRN;
		osxJDK;
		osxAndroid;
	
  	else
		echo "${RED}Could not detect operating system"
		exit
  	fi
}

# Checks if node is installed
linuxNode() {
  	if which node > /dev/null
	then
		echo "${GREEN}Node is installed, skipping..."
	else
		echo "${RED}Node is not installed, please install it!"
	  	echo "${CYAN}Follow instructions for installing Node on your OS -> https://nodejs.org/en/download/package-manager/"
		evince https://nodejs.org/en/download/package-manager/
		exit
	fi
}

# Check if React-Native-Cli is installed
installRN() {
	if which react-native > /dev/null
	then
		echo "${GREEN}React-Native-Cli is installed, skipping..."
	else
		echo "${RED}React-Native-Cli is not installed!"
		echo "${CYAN}Installing React-Native-Cli..."
		npm install -g react-native-cli
	fi
}

# Checks if JDK is installed
linuxJDK() {
	if which java > /dev/null
	then
		echo "${GREEN}JDK is installed, skipping..."
	else
		echo "${RED}JDK is not installed, please install it!"
		echo "${CYAN} Install Java Development Kif from here -> https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"
		evince https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
		exit
	fi
}

# Checks is Android Studio is installed
linuxAndroid() {
  
	if which Android > /dev/null
	then
	  echo  "${GREEN}Android Studio is installed, skipping..."
	else
	  echo "${RED}Android Studio is not installed!"
	  echo "${CYAN}Install Android Studio from here -> https://developer.android.com/studio/"
	  evince https://developer.android.com/studio/
	  exit
	fi
}

# Checks if Node is installed
osxNode() {
  if which node > /dev/null
	then
		echo "${GREEN}Node is installed, skipping..."
	else
	  echo "${RED}Node is not installed"
	  echo "${GREEN}Installing Node..."
		brew install node
		npm install npm@4.6.1
	fi
}

# Checks if Wacthman is installed
osxWatchman() {
	if which watchman > /dev/null
	then
		echo "${GREEN}Watchman is installed, skipping..."
	else
		echo "${RED}Watchman is not installed"
		echo "${GREEN}Installing Watchman..."
		brew install watchman
	fi
}

# Check if JDK is installed
osxJDK() {
	if which java > /dev/null
	then
		echo "${GREEN}JDK is installed, skipping..."
	else
		echo "${RED}JDK is not install, please install it!"
		echo "${CYAN} Install Java Development Kif from here -> https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"
		open https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
		exit
	fi
}

# Check is Android Studio is installed
osxAndroid() {
	if which Android > /dev/null
	then
	  echo  "${GREEN}Android Studio is installed, skipping..."
	else
	  echo "${RED}Android Studio is not installed!"
	  echo "${CYAN}Install Android Studio from here -> https://developer.android.com/studio/"
	  open https://developer.android.com/studio/
	  exit
	fi
}

# removes and creates new Main Activity with navigation modules for Android
changeMainActivity() {
	rm android/app/src/main/java/com/$projname/MainActivity.java

  	cat > android/app/src/main/java/com/$lowercase/MainActivity.java << EOF
  	package com.$lowercase;

  	import com.facebook.react.ReactActivity;
  	import com.facebook.react.ReactActivityDelegate;
  	import com.facebook.react.ReactRootView;
  	import com.swmansion.gesturehandler.react.RNGestureHandlerEnabledRootView;

  	public class MainActivity extends ReactActivity {

	  	/**
	  	 * Returns the name of the main component registered from JavaScript.
	  	 * This is used to schedule rendering of the component.
	  	 */
	  	@Override
	  	protected String getMainComponentName() {
		  return "$projname";
	  	}
	  
	  	@Override
	 	protected ReactActivityDelegate createReactActivityDelegate() {
		 	return new ReactActivityDelegate(this, getMainComponentName()) {
				  @Override
			  	protected ReactRootView createRootView() {
					  return new RNGestureHandlerEnabledRootView(MainActivity.this);
				  	}
		  	};
	  	}
  	}
EOF
}

# creates Home.js screen file
createHomeScreen() {
	echo "${GREEN}Creating Home screen"

	cat > src/screens/Home.js << EOF
	import React from 'react';
	import {View, StyleSheet, Text} from 'react-native';

	export default class Home extends React.Component {

		static navigationOptions = {
			title: 'Home'
		};

		render() {
			const {navigate} = this.props.navigation;
				return (
					<View style={styles.container}>
						<Text>Hello world!</Text>
					</View>
				);
		}
	}

	const styles = StyleSheet.create({
		container: {
			flex: 1,
			justifyContent: 'center',
			alignItems: 'center',
			backgroundColor: '#F5FCFF',
		},
		welcome: {
			fontSize: 20,
			textAlign: 'center',
			margin: 10,
		},
		instructions: {
			textAlign: 'center',
			color: '#333333',
			marginBottom: 5,
		},
	});
EOF
}

# creates Routes.js file for Navigation
createRoutes() {
  	echo "${GREEN}Creating Routes file and adding some code to it"

  	cat > Routes.js << EOF
  	import {createStackNavigator, createAppContainer} from 'react-navigation';
  	import Home from "./src/screens/Home";

  	const MainNavigator = createStackNavigator({
		Home: {screen: Home},
 	 });

  	const Routes = createAppContainer(MainNavigator);
  	export default Routes;
EOF
}

createActionsFile() {
	echo "${GREEN}Creating Actions file and adding some code to it"
	cat > src/actions/actions.js << EOF
	import {DO_SMTHG} from '../constants/constants'

	export function doSomething() {
	  return {type: DO_SMTHG}
	}
EOF
}

createConstantsFile(){
	cat > src/constants/constants.js << EOF

	export const DO_SMTHG = 'DO_SOMETHING'
EOF
}

createRootReducerFile(){
	cat > src/reducers/rootReducer.js << EOF

	import {DO_SMTHG} from "../constants/constants";

	const initialState = {

	};

	const rootReducer = (state = initialState, action) => {
		return state;
	};

	export default rootReducer;
EOF
}

createStoreFile(){
	cat > src/store/store.js << EOF

	import { createStore } from "redux";
	import rootReducer from "../reducers/rootReducer";

	const store = createStore(rootReducer);
	export default store;
EOF
}

# removes App.js file previously created and generates a new one
regenerateAppFile() {
  	echo "${GREEN}Regenerating App.js file" 

  	rm App.js

  	cat > App.js << EOF
  	import React, {Component} from "react";
  	import { Provider } from "react-redux";
  	import Routes from "./Routes";
  	import store from "./src/store/store";

  	class App extends Component {
  		render() {
  			return (
  				<Provider store={store}>
					 <Routes>
					 </Routes>
				</Provider>
  			)
  		}
  	}
  	export default App;
EOF
}

# create a file with some already requirements included
createRequirements() {
  	cat > requirements.txt << EOF
  	# Complete here with all the requirements your project needs.

  	react-navigation;
	react-native-gesture-handler;
	react-art;
	react-dom;
	react-native-web;
  	react-native-gesture-handler;
  	react-native-router-flux;
  	redux;
	react-redux;
  	rxjs;
EOF
}

main() {
  	detectProjName

  	detectProjPath
  	cd $projpath;

  	detectOS

  	# creates react-native project
  	echo "${GREEN}Creating react project...";
  	react-native init $projname;

  	# changes to project directory
  	echo "${GREEN}Changing to Project Directory...";
  	cd $projname;

  	# creates bundle for android
  	echo "${GREEN}Creating bundle for Android...";
  	mkdir android/app/src/main/assets;
  	react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res;


  	# installs dependencies for react-native-gesture-handler
  	echo "${GREEN}Installing dependencies for react-native-gesture-handler..."
  	npm i react-art;
  	npm i react-dom;
  	npm i react-router-dom;
  	npm i react-native-web;

  	# installs and linkks navigation module
  	echo "${GREEN}Installing and Linking Navigation..."
  	npm install --save react-navigation;
  	npm install --save react-native-gesture-handler;
  	react-native link react-native-gesture-handler;

  	# installs router-flux
  	echo "${GREEN}Installing Router-Flux..."
  	npm i react-native-router-flux --save

  	# installs redux and react-redux
  	echo "${GREEN}Installing Redux..."
  	npm install --save redux;
  	npm install --save react-redux;

  	# installs React Extensions for JavaScript
  	echo "${GREEN}Installing Reactive Extensions for JavaScript..."
  	npm install rxjs

  	# Changes MainActivity.java
  	changeMainActivity

  	# creates some directories
  	echo "${GREEN}Creating src, components and screen directories"
  	mkdir src;
  	mkdir src/actions;
  	createActionsFile;
  	mkdir src/components;
  	mkdir src/constants;
  	createConstantsFile;
  	mkdir src/reducers;
  	createRootReducerFile;
  	mkdir src/screens;
  	createHomeScreen;
  	mkdir src/store;
  	createStoreFile;

  	# creates Routes.js
  	createRoutes;

  	# generation of a new App.js
  	regenerateAppFile;

  	# creates requirements.txt
  	createRequirements;

  	echo "${GREEN}Complete Successfully"

  	cd $projpath/$projname/;
}

main
