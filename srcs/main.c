/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/13 16:13:07 by jmaia             #+#    #+#             */
/*   Updated: 2022/03/02 16:19:56 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <X11/extensions/shape.h>
#include <X11/extensions/Xfixes.h>

#include "goose.h"

#include <unistd.h>
#include <time.h>
#include <vlc/vlc.h>

void	play_video(Window w, char *path, libvlc_instance_t **inst,
			libvlc_media_player_t **mp);
void	stop_video(libvlc_instance_t *inst, libvlc_media_player_t *mp);

static void	remove_input(t_xvar *mlx_ptr, t_win_list *w_list);
Bool MakeAlwaysOnTop(Display* display, Window root, Window mywin);

int	main(int ac, char **av)
{	
	t_xvar					*mlx_ptr;
	t_win_list				*w_list;
	libvlc_instance_t		*inst;
	libvlc_media_player_t	*mp;
	int						x, y, height, width;

	x = 0;
	y = 0;
	height = 100;
	width = 100;
	if (ac < 2)
	{
		fprintf(stderr, "Usage: %s <path_to_media> [<x> <y> [<height> <width>]]\n", av[0]);
		return (1);
	}
	if (ac >= 4)
	{
		x = atoi(av[2]);
		y = atoi(av[3]);
	}
	if (ac >= 6)
	{
		height = atoi(av[4]);
		width = atoi(av[5]);
	}
	XInitThreads();
	mlx_ptr = mlx_init();
	if (!mlx_ptr)
		return (0);
	w_list = mlx_new_window_without_border(mlx_ptr, x, y, width, height, "Goose");
	if (!mlx_ptr->win_list)
	{
		destroy_everything(mlx_ptr, w_list);
		return (0);
	}
	remove_input(mlx_ptr, w_list);
	play_video(w_list->window, av[1], &inst, &mp);
	MakeAlwaysOnTop(mlx_ptr->display, mlx_ptr->root, w_list->window);
	while (1)
		;
}

static void	remove_input(t_xvar *mlx_ptr, t_win_list *w_list)
{
	XserverRegion	region;
	XRectangle		rect;

	memset(&rect, 0, sizeof(rect));
	region = XFixesCreateRegion(mlx_ptr->display, &rect, 1);
	XFixesSetWindowShapeRegion(mlx_ptr->display, w_list->window, ShapeInput,
		0, 0, region);
	XFixesDestroyRegion(mlx_ptr->display, region);
}
