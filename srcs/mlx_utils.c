/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   mlx_utils.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/12/13 11:13:28 by jmaia             #+#    #+#             */
/*   Updated: 2022/01/13 16:07:19 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "banana42.h"

void	destroy_everything(t_xvar *mlx_ptr, t_win_list *w_list)
{
	if (!mlx_ptr)
		return ;
	if (w_list)
		mlx_destroy_window(mlx_ptr, w_list);
	mlx_destroy_display(mlx_ptr);
	free(mlx_ptr);
}
