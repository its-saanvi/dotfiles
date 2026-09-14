{ config, lib, pkgs, dotfiles, ... }@inputs:
{
	hjem.users.saanvi = {
		enable = true;
		files = {
			".config/nvim" = {
				source = "${dotfiles}/nvim";
				recursive = true;
			}
		}
	}
}
