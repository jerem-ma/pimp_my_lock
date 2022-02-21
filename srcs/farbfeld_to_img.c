/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   farbfeld_to_img.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/02/10 15:27:43 by jmaia             #+#    #+#             */
/*   Updated: 2022/02/11 16:01:16 by jmaia            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "farbfeld_to_img.h"

static int	parse_header(t_file *file, unsigned int *width,
				unsigned int *height);
static int	get_n_next_bytes(t_file *file, char *bytes, int n);
static void	reverse(char *array, int len);
static int	get_pixels(t_file *file, unsigned int *data);

t_img	*farbfeld_to_img(t_xvar *mlx_ptr, const char *path)
{
	t_img			*img;
	t_file			file;
	unsigned int	width;
	unsigned int	height;
	int				err;

	file = open_file(path);
	if (file.fd == -1)
		return (0);
	err = !parse_header(&file, &width, &height);
	if (err)
	{
		close_file(file);
		return (0);
	}
	img = mlx_new_image(mlx_ptr, width, height);
	if (!img)
	{
		close_file(file);
		return (0);
	}
	get_pixels(&file, (unsigned int *)img->data);
	return (img);
}

static int	parse_header(t_file *file, unsigned int *width,
		unsigned int *height)
{
	int	err;

	err = !(get_n_next_bytes(file, 0, 8) != 8);
	err += get_n_next_bytes(file, (char *)width, 4) != 4;
	err += get_n_next_bytes(file, (char *)height, 4) != 4;
	reverse((char *)width, 4);
	reverse((char *)height, 4);
	if (err)
		return (1);
	return (0);
}

static void	reverse(char *array, int len)
{
	int		i;
	char	tmp;

	i = 0;
	while (i < len / 2)
	{
		tmp = array[i];
		array[i] = array[len - i - 1];
		array[len - i - 1] = tmp;
		i++;
	}
}

static int	get_n_next_bytes(t_file *file, char *bytes, int n)
{
	int		i;
	char	c;

	i = 0;
	while (i < n && file->end)
	{
		c = get_next_char(file).c;
		if (bytes)
			bytes[i] = c;
		i++;
	}
	return (i);
}

static int	get_pixels(t_file *file, unsigned int *data)
{
	int					i;
	int					n_read;
	unsigned long int	l_color;
	unsigned int		color;

	i = 0;
	while (file->end)
	{
		n_read = get_n_next_bytes(file, (char *)&l_color, 8);
		if (n_read != 8)
			return (1);
		((char *)&color)[0] = ((char *)&l_color)[4];
		((char *)&color)[1] = ((char *)&l_color)[2];
		((char *)&color)[2] = ((char *)&l_color)[0];
		((char *)&color)[3] = ((char *)&l_color)[6];
		data[i] = color;
		i++;
	}
	return (0);
}
