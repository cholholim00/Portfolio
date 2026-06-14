// src/index.js
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App'; // 여기서 App을 가져올 때 에러가 나면 전체가 흰 화면이 됩니다.

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);