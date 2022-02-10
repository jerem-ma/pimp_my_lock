/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   farbfeld_to_img.h                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/02/10 16:21:31 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/10 16:22:58 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef FARBFELD_TO_IMG
# define FARBFELD_TO_IMG

# include "mlx.h"
# include "mlx_int.h"

# include "files.h"

t_img	*farbfeld_to_img(t_xvar *mlx_ptr, const char *path);

#endif
