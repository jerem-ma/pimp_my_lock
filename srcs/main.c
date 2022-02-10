/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/13 16:13:07 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/10 19:06:53 by jmaia            ###   ########.fr       */
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
	w_list = mlx_new_window_without_border(mlx_ptr, img->width, img->height, "Goose");
	if (!mlx_ptr->win_list)
	{
		destroy_everything(mlx_ptr, w_list);
		return (0);
	}
	mlx_put_image_to_window(mlx_ptr, w_list, img, 0, 0);
	sleep(500);
	destroy_everything(mlx_ptr, w_list);
}
