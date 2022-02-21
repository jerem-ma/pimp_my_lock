/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   play_video.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/14 21:08:57 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/17 16:08:26 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

# include <X11/Xlib.h>
# include <vlc/vlc.h>
# include "mlx.h"
# include "mlx_int.h"
# include "mlx_ext.h"

void	play_video(Window w, char *path, libvlc_instance_t **inst,
		libvlc_media_player_t **mp)
{
	libvlc_media_t			*m;
	const char *const		av[] = {"--input-repeat", "65535"};

	*inst = libvlc_new(2, av);
	m = libvlc_media_new_path(*inst, path);
	*mp = libvlc_media_player_new_from_media(m);
	libvlc_media_release(m);
	libvlc_media_player_set_xwindow(*mp, w);
	libvlc_media_player_play(*mp);
}
