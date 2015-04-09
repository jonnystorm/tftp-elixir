# Copyright © 2015 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule TFTP do
  defp shell_cmd(command) do
    command
      |> :binary.bin_to_list
      |> :os.cmd
      |> :binary.list_to_bin
  end

  defp get_tftp_error(output) do
    case output do
      "" ->
        :ok
      error ->
        case String.strip(error) do
          "Error code 1: File not found" ->
            {:error, :enoent}
          "Transfer timed out." ->
            {:error, :etimedout}
          unknown_error ->
            {:error, unknown_error}
        end
    end
  end

  defp exec_tftp_cmd(tftp_command, host, mode) when mode in [:ascii, :binary] do
    "tftp -m #{mode} #{host} -c #{tftp_command}"
      |> shell_cmd
      |> get_tftp_error
  end

  defp split_file_path(filepath) do
    [file|dirs] = filepath
      |> String.split("/")
      |> Enum.reverse

    case (dirs |> Enum.reverse |> Enum.join("/")) do
      "" ->
        {".", file}
      path ->
        {path, file}
    end
  end

  @spec get(String.t, :ascii | :binary) :: :ok | {:error, atom} | {:error, String.t}
  def get(filepath, host, mode \\ :ascii) do
    {path, file} = filepath
      |> String.replace(~r/'/, "")
      |> split_file_path

    "get '#{path}/#{file}'"
      |> exec_tftp_cmd(host, mode)
  end

  @spec put(String.t, :ascii | :binary) :: :ok | {:error, atom} | {:error, String.t}
  def put(filepath, host, mode \\ :ascii) do
    {path, file} = filepath
      |> String.replace(~r/'/, "")
      |> split_file_path

    "put '#{path}/#{file}' /#{file}"
      |> exec_tftp_cmd(host, mode)
  end
end
