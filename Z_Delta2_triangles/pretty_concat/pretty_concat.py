"""Utility functions to concatenate multi-line strings horizontally."""
# Author: Johannes Hofscheier.


from functools import reduce


def str_to_rect(str_list, height=None, width=None, whitespace=' '):
    """Transforms a list of strings into a list of strings of length width
       (appending spaces to shorter lines). Inserts lines [whitespace*width]
       above and below such that original strings are vertically centered.

       (Think of returned list representing a rectangular multi-line string of
       given width and height with addtional lines containing 'whitespace'.)

    Args:
      str_list: list of strings
      height: integer giving number of strings in final list
      width: integer giving the length of every string in final list
      whitespace: character to use for addtional lines to add above/below
    """
    n_lines = len(str_list)
    max_line_len = max([len(x) for x in str_list])

    width = width if width is not None else max_line_len
    if width < max_line_len:
        raise ValueError('str_to_rect: width must be greater than or equal'
                         'to length of maximal line in mult_line_str')

    height = height if height is not None else n_lines
    if height < n_lines:
        raise ValueError('str_to_rect: height must be greater than or euqal'
                         'to number of lines in mult_line_str')

    n_additional_lines = (height-n_lines)
    n_above = n_additional_lines//2
    n_below = (n_additional_lines+n_additional_lines % 2)//2

    return [whitespace*width]*n_above + \
        ['{0:<{1}}'.format(s, width) for s in str_list] + \
        [whitespace*width]*n_below


def join_two_pretty(str1, str2):
    """Concatenate two multi-line strings horizontally.
       Align them vertically centered.

    Args:
      str1: string which can contain multiple lines (separated by '\n')
      str2: string which can contain multiple lines (separated by '\n')
    """
    str1_lines = str1.split('\n')
    str2_lines = str2.split('\n')
    str1_n_lines = len(str1_lines)
    str2_n_lines = len(str2_lines)
    height = max(str1_n_lines, str2_n_lines)
    return '\n'.join([x + y for x, y in
                      zip(str_to_rect(str1_lines, height),
                          str_to_rect(str2_lines, height))])


def join_pretty(pretty_str_list):
    """"Concatenate list of multi-line strings horizontally and align them
        vertically centered.

    Args:
      pretty_str_list: list of strings which can contain multiple lines

    Returns:
      One single string.
    """
    return reduce(join_two_pretty, pretty_str_list)
