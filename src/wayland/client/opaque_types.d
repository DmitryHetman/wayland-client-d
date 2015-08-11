/+
 +  Wayland copyright:
 +  Copyright © 2008 Kristian Høgsberg
 +
 +  Permission is hereby granted, free of charge, to any person
 +  obtaining a copy of this software and associated documentation files
 +  (the "Software"), to deal in the Software without restriction,
 +  including without limitation the rights to use, copy, modify, merge,
 +  publish, distribute, sublicense, and/or sell copies of the Software,
 +  and to permit persons to whom the Software is furnished to do so,
 +  subject to the following conditions:
 +
 +  The above copyright notice and this permission notice (including the
 +  next paragraph) shall be included in all copies or substantial
 +  portions of the Software.
 +
 +  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 +  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 +  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 +  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 +  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 +  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 +  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 +  SOFTWARE.
 +/
/+
 +  D bindings copyright:
 +  Copyright © 2015 Rémi Thebault
 +/

module wayland.client.opaque_types;

extern (C):

struct wl_object;

struct wl_client;
/** \class wl_proxy
 *
 * \brief Represents a protocol object on the client side.
 *
 * A wl_proxy acts as a client side proxy to an object existing in the
 * compositor. The proxy is responsible for converting requests made by the
 * clients with \ref wl_proxy_marshal() into Wayland's wire format. Events
 * coming from the compositor are also handled by the proxy, which will in
 * turn call the handler set with \ref wl_proxy_add_listener().
 *
 * \note With the exception of function \ref wl_proxy_set_queue(), functions
 * accessing a wl_proxy are not normally used by client code. Clients
 * should normally use the higher level interface generated by the scanner to
 * interact with compositor objects.
 *
 */
struct wl_proxy;

/** \class wl_display
 *
 * \brief Represents a connection to the compositor and acts as a proxy to
 * the wl_display singleton object.
 *
 * A wl_display object represents a client connection to a Wayland
 * compositor. It is created with either \ref wl_display_connect() or
 * \ref wl_display_connect_to_fd(). A connection is terminated using
 * \ref wl_display_disconnect().
 *
 * A wl_display is also used as the \ref wl_proxy for the wl_display
 * singleton object on the compositor side.
 *
 * A wl_display object handles all the data sent from and to the
 * compositor. When a \ref wl_proxy marshals a request, it will write its wire
 * representation to the display's write buffer. The data is sent to the
 * compositor when the client calls \ref wl_display_flush().
 *
 * Incoming data is handled in two steps: queueing and dispatching. In the
 * queue step, the data coming from the display fd is interpreted and
 * added to a queue. On the dispatch step, the handler for the incoming
 * event set by the client on the corresponding \ref wl_proxy is called.
 *
 * A wl_display has at least one event queue, called the <em>default
 * queue</em>. Clients can create additional event queues with \ref
 * wl_display_create_queue() and assign \ref wl_proxy's to it. Events
 * occurring in a particular proxy are always queued in its assigned queue.
 * A client can ensure that a certain assumption, such as holding a lock
 * or running from a given thread, is true when a proxy event handler is
 * called by assigning that proxy to an event queue and making sure that
 * this queue is only dispatched when the assumption holds.
 *
 * The default queue is dispatched by calling \ref wl_display_dispatch().
 * This will dispatch any events queued on the default queue and attempt
 * to read from the display fd if it's empty. Events read are then queued
 * on the appropriate queues according to the proxy assignment.
 *
 * A user created queue is dispatched with \ref wl_display_dispatch_queue().
 * This function behaves exactly the same as wl_display_dispatch()
 * but it dispatches given queue instead of the default queue.
 *
 * A real world example of event queue usage is Mesa's implementation of
 * eglSwapBuffers() for the Wayland platform. This function might need
 * to block until a frame callback is received, but dispatching the default
 * queue could cause an event handler on the client to start drawing
 * again. This problem is solved using another event queue, so that only
 * the events handled by the EGL code are dispatched during the block.
 *
 * This creates a problem where a thread dispatches a non-default
 * queue, reading all the data from the display fd. If the application
 * would call \em poll(2) after that it would block, even though there
 * might be events queued on the default queue. Those events should be
 * dispatched with \ref wl_display_dispatch_(queue_)pending() before
 * flushing and blocking.
 */
struct wl_display;

/** \class wl_event_queue
 *
 * \brief A queue for \ref wl_proxy object events.
 *
 * Event queues allows the events on a display to be handled in a thread-safe
 * manner. See \ref wl_display for details.
 *
 */
struct wl_event_queue;
struct wl_global;
