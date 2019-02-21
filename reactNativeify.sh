#!/bin/bash

GREEN='\033[0;32m'    # Green Color
RED='\033[0;31m'      # Red Color
CYAN='\033[0;36m'     # Cyan Color
NC='\033[0m'          # No Color

projname=$1     # project name
lowercase=$(echo "$projname" | tr '[:upper:]' '[:lower:]') # converts to lower case

# Checks if project has name
detectProjName() {
  if [ -z "$projname" ]
    then
      echo "${CYAN}Usage <sh reactProject.sh projName>"
      exit
  fi
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
    osxAndroid
    
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

  cat > Home.js << EOF
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
  import Home from "./Home";

  const MainNavigator = createStackNavigator({
    Home: {screen: Home},
  });

  const App = createAppContainer(MainNavigator);
  export default App;
EOF
}

# removes App.js file previously created and generates a new one
regenerateAppFile() {
  echo "${GREEN}Regenerating App.js file" 

  rm App.js
  cat > App.js << EOF
  import React, {Component} from "react";
  import Routes from "./Routes";

  const App = () => <Routes/>;
  export default App;
EOF
}

# create a file with some already requirements included
createRequirements() {
  cat > requirements.txt << EOF
  # Complete here with all the requirements your project needs.

  react-navigation;
  react-native-gesture-handler;
  rxjs
EOF
}

main() {
  detectProjName
  detectOS

  #echo "${GREEN}Changing to Documents Directory...";
  #cd ~/Documents/;

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

  # installs and linkks navigation module
  echo "${GREEN}Installing and Linking Navigation..."
  npm install --save react-navigation;
  npm install --save react-native-gesture-handler;
  react-native link react-native-gesture-handler;

  # installs React Extensions for JavaScript
  echo "${GREEN}Installing Reactive Extensions for JavaScript..."
  npm install rxjs

  # Changes MainActivity.java
  changeMainActivity

  # creates some directories
  echo "${GREEN}Creating src, components and screen directories"
  mkdir src;
  mkdir src/components;
  mkdir src/screens;

  # creates Home.js
  createHomeScreen;

  # creates Routes.js
  createRoutes;

  # generation of a new App.js
  regenerateAppFile;

  # creates requirements.txt
  createRequirements;

  echo "${GREEN}Complete Successfully"
}

main