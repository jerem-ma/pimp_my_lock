/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/13 16:13:07 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/08 17:30:45 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <X11/extensions/Xfixes.h>

int	main(void)
{
	t_xvar					*mlx_ptr;
	t_win_list				*w_list;
	libvlc_instance_t		*inst;
	libvlc_media_player_t	*mp;

	XInitThreads();
	mlx_ptr = mlx_init();
	if (!mlx_ptr)
		return (0);
	w_list = mlx_new_window_fullscreen(mlx_ptr, "Banana");
	if (!mlx_ptr->win_list)
	{
		destroy_everything(mlx_ptr, w_list);
		return (0);
	}
	XFixesHideCursor(mlx_ptr->display, mlx_ptr->root);
	grab_keyboard(mlx_ptr, w_list->window);
	play_video(w_list->window, "video.mp4", &inst, &mp);
	wait_for_code(mlx_ptr, w_list);
	ungrab_keyboard(mlx_ptr);
	stop_video(inst, mp);
	destroy_everything(mlx_ptr, w_list);
}
