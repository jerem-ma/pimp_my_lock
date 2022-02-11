/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/13 16:13:07 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/11 13:46:34 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <X11/extensions/Xfixes.h>

#include "goose.h"

#include <unistd.h>

int	main(void)
{	
	t_xvar					*mlx_ptr;
	t_win_list				*w_list;
	t_img					*img;

	mlx_ptr = mlx_init();
	XSynchronize(mlx_ptr->display, True);
	if (!mlx_ptr)
		return (0);
	img = farbfeld_to_img(mlx_ptr, "res/little_goose.ff");
	if (!img)
	{
		destroy_everything(mlx_ptr, 0);
		return (0);
	}
	w_list = mlx_new_window_fullscreen(mlx_ptr, "Goose");
	if (!mlx_ptr->win_list)
	{
		destroy_everything(mlx_ptr, w_list);
		return (0);
	}
	mlx_put_image_to_window(mlx_ptr, w_list, img, 0, 0);

	int	x;
	int	y;
	while (1)
	{
		mlx_mouse_get_pos(mlx_ptr, w_list, &x, &y);
		mlx_put_image_to_window(mlx_ptr, w_list, img, x, y);
		usleep(100000);
	}
	sleep(500);
	destroy_everything(mlx_ptr, w_list);
}
