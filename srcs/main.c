/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/13 16:13:07 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/10 15:01:24 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <X11/extensions/Xfixes.h>

#include "goose.h"

#include <unistd.h>

int	main(void)
{	

	t_xvar					*mlx_ptr;
	t_win_list				*w_list;

	mlx_ptr = mlx_init();
	if (!mlx_ptr)
		return (0);
	w_list = mlx_new_window_fullscreen(mlx_ptr, "Goose");
	if (!mlx_ptr->win_list)
	{
		destroy_everything(mlx_ptr, w_list);
		return (0);
	}
	sleep(2);
	destroy_everything(mlx_ptr, w_list);
}
