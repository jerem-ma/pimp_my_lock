/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   mlx_ext.h                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/13 17:56:47 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/10 19:07:19 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef MLX_EXT_H
# define MLX_EXT_H

void	*mlx_new_window_fullscreen(t_xvar *xvar, char *title);
void	*mlx_new_window_without_border(t_xvar *xvar,int size_x,int size_y,char *title);

#endif
