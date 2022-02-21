/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   stop_video.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/15 01:14:40 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/11 18:35:08 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

# include <vlc/vlc.h>

void	stop_video(libvlc_instance_t *inst, libvlc_media_player_t *mp)
{
	libvlc_media_player_stop(mp);
	libvlc_media_player_release(mp);
	libvlc_release(inst);
}
