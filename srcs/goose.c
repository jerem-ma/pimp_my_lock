/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   goose.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/02/11 14:04:49 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/11 18:10:29 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "goose.h"

Bool MakeAlwaysOnTop(Display* display, Window root, Window mywin);

void	goose(t_xvar *mlx_ptr, t_win_list *w_list, t_img *img)
{
	t_goose	goose;

	MakeAlwaysOnTop(mlx_ptr->display, mlx_ptr->root, w_list->window);
	while (1)
	{
		mlx_get_screen_size(mlx_ptr, &goose.x, &goose.y);
		goose.x = rand() % goose.x;
		goose.y = rand() % goose.y;
		mlx_put_image_to_window(mlx_ptr, w_list, img, goose.x, goose.y);
		XClearArea(mlx_ptr->display, w_list->window, goose.x, goose.y,
			img->width, img->height, 0);
	}
}

#define _NET_WM_STATE_REMOVE        0    // remove/unset property
#define _NET_WM_STATE_ADD           1    // add/set property
#define _NET_WM_STATE_TOGGLE        2    // toggle property

Bool MakeAlwaysOnTop(Display* display, Window root, Window mywin)
{
    Atom wmStateAbove = XInternAtom( display, "_NET_WM_STATE_ABOVE", 1 );
    if( wmStateAbove != None ) {
        printf( "_NET_WM_STATE_ABOVE has atom of %ld\n", (long)wmStateAbove );
    } else {
        printf( "ERROR: cannot find atom for _NET_WM_STATE_ABOVE !\n" );
        return False;
    }

    Atom wmNetWmState = XInternAtom( display, "_NET_WM_STATE", 1 );
    if( wmNetWmState != None ) {
        printf( "_NET_WM_STATE has atom of %ld\n", (long)wmNetWmState );
    } else {
        printf( "ERROR: cannot find atom for _NET_WM_STATE !\n" );
        return False;
    }

    // set window always on top hint
    if( wmStateAbove != None )
    {
        XClientMessageEvent xclient;
        memset( &xclient, 0, sizeof (xclient) );
        //
        //window  = the respective client window
        //message_type = _NET_WM_STATE
        //format = 32
        //data.l[0] = the action, as listed below
        //data.l[1] = first property to alter
        //data.l[2] = second property to alter
        //data.l[3] = source indication (0-unk,1-normal app,2-pager)
        //other data.l[] elements = 0
        //
        xclient.type = ClientMessage;
        xclient.window = mywin;              // GDK_WINDOW_XID(window);
        xclient.message_type = wmNetWmState; //gdk_x11_get_xatom_by_name_for_display( display, "_NET_WM_STATE" );
        xclient.format = 32;
        xclient.data.l[0] = _NET_WM_STATE_ADD; // add ? _NET_WM_STATE_ADD : _NET_WM_STATE_REMOVE;
        xclient.data.l[1] = wmStateAbove;      //gdk_x11_atom_to_xatom_for_display (display, state1);
        xclient.data.l[2] = 0;                 //gdk_x11_atom_to_xatom_for_display (display, state2);
        xclient.data.l[3] = 0;
        xclient.data.l[4] = 0;
        //gdk_wmspec_change_state( FALSE, window,
        //  gdk_atom_intern_static_string ("_NET_WM_STATE_BELOW"),
        //  GDK_NONE );
        XSendEvent( display,
          //mywin - wrong, not app window, send to root window!
          root, // <-- DefaultRootWindow( display )
          False,
          SubstructureRedirectMask | SubstructureNotifyMask,
          (XEvent *)&xclient );

        XFlush(display);

        return True;
    }

    return False;
}
