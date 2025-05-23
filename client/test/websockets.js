const WebSocket = require('ws')

const socket = new WebSocket('ws://afterhours.praxiseng.com/ws/hunt?huntId=67476e8cbd0c6d6a4bdcf9d6&teamId=Team52&huntAlone=false');
socket.onopen = () => {
  console.log('WebSocket connection opened');
  socket.send('Hello from the client!');
};
socket.onmessage = (event) => {
  console.log('Message from server:', event.data);
};
socket.onerror = (event) => {
  console.error('WebSocket error:', event);
  if (event.message) {
    console.error('Error message:', event.message);
  } else {
    console.error('WebSocket error event:', event);
  }
};
socket.onclose = (event) => {
  console.log('WebSocket connection closed');
  console.log(`Code: ${event.code}, Reason: ${event.reason}`);
};
