/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   files.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <marvin@42.fr>                       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/08/24 12:31:46 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/11 14:56:49 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef FILES_H
# define FILES_H
# define SIZE_BUF 50
# include <fcntl.h>
# include <unistd.h>

typedef struct s_file
{
	int		fd;
	int		i;
	int		end;
	char	buf[SIZE_BUF];
}	t_file;
typedef struct s_char_file
{
	char	c;
	int		is_end;
}	t_char_file;
t_file		open_file(const char *path);
int			close_file(t_file file);
t_char_file	get_next_char(t_file *file);
int			is_end_reached(t_file *file);
#endif
