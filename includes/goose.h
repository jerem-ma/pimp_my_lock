/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   goose.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/13 15:55:57 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/08 17:35:18 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef GOOSE_H
# define GOOSE_H

# include <X11/Xlib.h>
# include <stdio.h>
# include <unistd.h>

# include "mlx.h"
# include "mlx_int.h"
# include "mlx_ext.h"

void    destroy_everything(t_xvar *mlx_ptr, t_win_list *w_list);

#endif
