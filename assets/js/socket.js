// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken, user_id: window.userId}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:

if (window.userToken) {
  socket.connect()
}

let parsedUrl = new URL(window.location.href);

let room_id = parsedUrl.pathname;

window.roomId = room_id
// Now that you are connected, you can join channels with a topic:

let channel = socket.channel("room:" + {})
//let channel = socket.channel("room:lobby" + {})

channel.on('change', function (payload) { // listen to the 'change' event
//  console.log(payload)
  let li = document.createElement("li"); // create new list item DOM element
  let name = payload.user_id || 'guest';    // get name from payload or set default
  li.innerHTML = '<b>' + name + '</b>: ' + payload.message; // set li contents
  ml.appendChild(li);                    // append to list
});


channel.on('room_list', function (payload) { 
  console.log(payload)
  let rl = document.createElement("li"); 
  li.innerHTML = '<b>' + name + '</b>: ' + payload.message;
  rl.appendChild(li);
});

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

//console.log(parsedUrl.pathname.replace(/^\/+/g, ''))


let rl = document.getElementById('room-list');        // list of rooms.
let ml = document.getElementById('message-list');        // list of messages.
//let name = document.getElementById('name');          // name of message sender
let msg = document.getElementById('msg');            // message input field

msg.addEventListener('keypress', function (event) {
      if (event.keyCode == 13 && msg.value.length > 0) { // don't sent empty msg.
          channel.push('message', { // send the message to the server on "shout" channel
                user_id: window.userId,     // get value of "name" of person sending the message
                message: msg.value    // get message text (value) from msg input field.
              });
          msg.value = '';         // reset the message input field for next message.
        }
    
});

