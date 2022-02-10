/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   files.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <marvin@42.fr>                       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/08/24 12:48:39 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/10 16:23:23 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "files.h"

t_file	open_file(const char *path)
{
	t_file	file;

	if (path[0] == '/' && path[1] == 0)
		file.fd = 0;
	else
		file.fd = open(path, O_RDONLY);
	if (file.fd == -1)
	{
		file.end = 0;
		return (file);
	}
	else
		file.end = SIZE_BUF;
	file.i = SIZE_BUF;
	return (file);
}

int	close_file(t_file file)
{
	if (file.fd == 0)
		return (0);
	close(file.fd);
	return (0);
}

int	is_end_reached(t_file *file)
{
	return (file->end == 0);
}

t_char_file	get_next_char(t_file *file)
{
	int			readed;
	t_char_file	c;

	c.is_end = 0;
	if (file->i == file->end)
	{
		readed = read(file->fd, file->buf, SIZE_BUF);
		file->end = readed;
		file->i = 0;
	}
	if (file->end == 0)
	{
		c.is_end = 1;
		return (c);
	}
	c.c = file->buf[file->i++];
	return (c);
}
