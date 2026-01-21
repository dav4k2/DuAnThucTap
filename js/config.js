const firebaseConfig = {
    apiKey: "AIzaSyDToqYlzh-Y6BKHxqEhhgtdVO7ZAkQ84gw",
    authDomain: "datt-eda89.firebaseapp.com",
    projectId: "datt-eda89",
    storageBucket: "datt-eda89.firebasestorage.app",
    messagingSenderId: "682485604915",
    appId: "1:682485604915:web:fb0a4f65d78a3739f37946",
    measurementId: "G-NG8BMBKBKZ"
};

if (typeof firebase !== 'undefined' && !firebase.apps.length) {
    firebase.initializeApp(firebaseConfig);
    console.log("Firebase đã được khởi tạo từ config.js");
}