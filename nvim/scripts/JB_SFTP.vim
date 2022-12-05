function! JB_SFTP_GetWorkDirPath()
	let work_dir_path=expand('%:p')[:-1-len(@%)]
	return work_dir_path
endfunction

function! JB_SFTP_GetIdeaDirPath()
	let work_dir_path = JB_SFTP_GetWorkDirPath()
	let idea_dir = substitute(work_dir_path."/.idea", "//", "/", "")
	return idea_dir
endfunction

function! JB_SFTP_GetConfigPath()
	let config_path = JB_SFTP_GetIdeaDirPath() . "/VIM_JB_SFTP.conf"
	return config_path
endfunction

function! JB_SFTP_GetHashSumLogPath()
	let hashsum_log_path = JB_SFTP_GetIdeaDirPath() . "/VIM_JB_SFTP_hashsum.log"
	return hashsum_log_path
endfunction

function! JB_SFTP_GetSSHKeyPath()
	let SSH_key_path = JB_SFTP_GetIdeaDirPath() . "/VIM_JB_SFTP_SSH_KEY"
	return SSH_key_path
endfunction


function! JB_SFTP_RandomizedString(thalength)
	" List containing the characters to use in the random string:
	let characters = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',]

	" Generate the random string
	let replaceString = ""
	for i in range(1, a:thalength)
		let index = GetRandomInteger() % len(characters)
		let replaceString = replaceString . characters[index]
	endfor
	return replaceString
endfunction

function! GetRandomInteger()
	if has('win32')
		return system("echo %RANDOM%")
	else
		return system("echo $RANDOM")
	endif
endfunction


function! JB_SFTP_Enabled_Status()
	let thaStatus = JB_SFTP_Enabled_Check()
	if thaStatus == 1
		echo "SFTP is enabled in this directory: ".expand('%:p')[:-1-len(@%)]
	else
		echo thaStatus
		return
	endif
endfunction

" deployment.xml
" sshConfigs.xml
" webServers.xml
function! JB_SFTP_Enabled_Check()
	let idea_dir = JB_SFTP_GetIdeaDirPath()
	" Look for .idea/
	if !isdirectory(idea_dir)
		return idea_dir." does not exist"
	endif
	
	" Look for deployment.xml
	if !filereadable(idea_dir."/deployment.xml")
		return idea_dir."/deployment.xml does not exist"
	endif

	" Look for webServers.xml
	if !filereadable(idea_dir."/webServers.xml")
		return idea_dir."/webServers.xml does not exist"
	endif

	" Look for sshConfigs.xml
	if !filereadable(idea_dir."/sshConfigs.xml")
		return idea_dir."/sshConfigs.xml does not exist"
	endif
	return 1
endfunction

function! JB_SFTP_Fetch_Settings()
	let thaStatus = JB_SFTP_Enabled_Check()
	if thaStatus != 1
		echo thaStatus
		return
	endif
	let idea_dir = JB_SFTP_GetIdeaDirPath()	
	let username = ""
	let thaHost = ""
	let thaPort = ""
	let rootmapping = ""
	let workmapping = ""
	let sshconfigID = ""
	let thaID = ""

	let temphost = ""
	let tempport = ""


	" start by getting the correct mapping
	let deploymentXML = readfile(idea_dir . "/deployment.xml")
	for line in deploymentXML
		"       ↓↓ yalla yalla
		if line =~ "<mapping "
			" Getting the host
			if line =~ " local=\"\$PROJECT_DIR\$\" "
				if line =~ " deploy=\""
					let rootmapping = split(line, " deploy=\"")[1]
					let rootmapping = split(rootmapping, "\"")[0]
				endif
			endif
		endif
	endfor

	if rootmapping == ""
		echo "Unable to grab local root mapping from /deployment.xml"
		return
	endif

	" Opening the sshConfigs.xml
	let sshconfigsXML = readfile(idea_dir . "/sshConfigs.xml")
	let c = 0
	for line in sshconfigsXML
		"       ↓↓ yalla yalla
		if line =~ "<sshConfig "

			if c == 1
				echo "There are multiple ssh config elements in sshConfigs."
				echo "Which one do you want to use for " . JB_SFTP_GetWorkDirPath() . " ?"
				echo " [1] -> " . username . "@" . temphost . ":" . tempport
			endif
			if c > 1
				echo " [".c."]: " . username . "@" . temphost . ":" . tempport
			endif

			" Getting the username
			if line =~ " username=\""
				let username = split(line, " username=\"")[1]
				let username = split(username, "\"")[0]
			endif

			" Getting the host
			if line =~ " host=\""
				let temphost = split(line, " host=\"")[1]
				let temphost = split(temphost, "\"")[0]
			endif


			" Getting the port
			if line =~ " port=\""
				let tempport = split(line, " port=\"")[1]
				let tempport = split(tempport, "\"")[0]
			endif


			" Getting the ID
			if line =~ " id=\""
				let thaID = split(line, " id=\"")[1]
				let thaID = split(thaID, "\"")[0]
			endif
			let c += 1
		endif
	endfor

	if c > 1
		echo " [".c."] -> " . username . "@" . temphost . ":" . tempport
		let chosenSSH = input('[ 1-'.c.' ] > ')
		echo "\n"
		if chosenSSH =~# '^\d\+$' " Not sure how to make this negative
			if chosenSSH > c
				echo "\n Input is out of range, quitting"
				return
			endif
			if 1 > chosenSSH
				echo "\n Input is out of range, quitting"
				return
			endif
		else
			echo "input is not a number, quitting"
			return
		endif
		" loop again...
		let c = 1
		for line in sshconfigsXML
			"       ↓↓ yalla yalla
			if line =~ "<sshConfig "

				if c != chosenSSH
					let c+=1
					continue
				endif

				" Getting the username
				if line =~ " username=\""
					let username = split(line, " username=\"")[1]
					let username = split(username, "\"")[0]
				endif

				" Getting the host
				if line =~ " host=\""
					let temphost = split(line, " host=\"")[1]
					let temphost = split(temphost, "\"")[0]
				endif

	
				" Getting the port
				if line =~ " port=\""
					let tempport = split(line, " port=\"")[1]
					let tempport = split(tempport, "\"")[0]
				endif


				" Getting the ID
				if line =~ " id=\""
					let thaID = split(line, " id=\"")[1]
					let thaID = split(thaID, "\"")[0]
				endif
				let c += 1
			endif
		endfor
	endif


	" Opening webServers.xml
	let webserversXML = readfile(idea_dir . "/webServers.xml")
	for line in webserversXML
		"       ↓↓ yalla yalla
		if line =~ "<fileTransfer "
			" Getting tha ssh config ID
			if line =~ " sshConfigId=\""
				let sshconfigID = split(line, " sshConfigId=\"")[1]
				let sshconfigID = split(sshconfigID, "\"")[0]
			endif
			if thaID != ""
				if thaID != sshconfigID
					continue
				endif
			endif
			
			" Getting the host
			if line =~ " host=\""
				let thaHost = split(line, " host=\"")[1]
				let thaHost = split(thaHost, "\"")[0]
			endif

			" Getting the port
			if line =~ " port=\""
				let thaPort = split(line, " port=\"")[1]
				let thaPort = split(thaPort, "\"")[0]
			endif
			
			" Getting tha mapping
			if line =~ " rootFolder=\""
				let workmapping = split(line, " rootFolder=\"")[1]
				let workmapping = split(workmapping, "\"")[0]
			endif
		endif
	endfor


	let mapping = substitute(rootmapping . workmapping, "//", "/", "")

	if thaHost == ""
		let thaHost = temphost
	endif
	if thaPort == ""
		let thaPort = tempport
	endif
	return [username, thaHost, thaPort, mapping, thaID]
endfunction

function! JB_SFTP_Show_Settings()
	let config_path = JB_SFTP_GetConfigPath()
	if filereadable(config_path)
		let thaStatus = JB_SFTP_Show_ConfigSettings()
	else
		let thaStatus = JB_SFTP_Fetch_Settings()
	endif
	if type(thaStatus) == v:t_list
		if thaStatus[0] == ""
			echo "Username missing"
			return
		endif
		echo "Username --> " . thaStatus[0]

		if thaStatus[1] == ""
			echo "Host missing"
			return
		endif
		echo "Host --> " . thaStatus[1]

		if thaStatus[2] == ""
			echo "Port missing"
			return
		endif
		echo "Port --> " . thaStatus[2]

		if thaStatus[3] == ""
			echo "Mapping missing"
			return
		endif
		echo "Mapping --> " . thaStatus[3]
	else
		echo thaStatus
		return
	endif
endfunction

function! JB_SFTP_Show_ConfigSettings()
	let config_path = JB_SFTP_GetConfigPath()
	if !filereadable(config_path)
		echo "There is no config found in:"
		echo "  " . config_path . "\n"
		echo "Please regenerate config, or manually write it"
		return
	else
		let config_settings = readfile(config_path)
		return config_settings
	endif
endfunction

function! JB_SFTP_ResetConfig()
	call JB_SFTP_GenerateConfig()
endfunction

function! JB_SFTP_GenerateConfig()
	let config_path = JB_SFTP_GetConfigPath()
	let thaStatus = JB_SFTP_Fetch_Settings()
	if type(thaStatus) != v:t_list
		return
	endif
	if filereadable(config_path)
		echo "Config file already exist, do you want to replace it?"
		echo "  \"" . config_path . "\""
		let chosenANSWER = input('[ y/n ] > ')
		echo "\n"
		if tolower(chosenANSWER) == "y"
			call delete(config_path)
			call writefile(thaStatus, config_path, "a")
		else
			echo "Well then, not doing anything then"
			return
		endif
	else
		call writefile(thaStatus, config_path, "a")
	endif
endfunction

function! JB_SFTP_ValidateConfig(onlyReturn)
	let config_settings = JB_SFTP_Show_ConfigSettings()
	if config_settings[0] == ""
		echo "Username missing"
		return
	endif
	
	if config_settings[1] == ""
		echo "Host missing"
		return
	endif
	
	if config_settings[2] == ""
		echo "Port missing"
		return
	endif
	
	if config_settings[3] == ""
		echo "Mapping missing"
		return
	endif
	if a:onlyReturn == 1
		return config_settings
	else
		echo "Username --> " . config_settings[0]
		echo "Host --> " . config_settings[1]
		echo "Port --> " . config_settings[2]
		echo "Mapping --> " . config_settings[3] . "\n"
		echo "┌──────────────────────────────────────────────────────────────┐"
		echo "│ Looks ok, or I mean.. my crappy code might not figure it out │"
		echo "└──────────────────────────────────────────────────────────────┘"
		return
	endif
endfunction

function! JB_SFTP_GenerateSSHKeyFile()
	let config_settings = JB_SFTP_ValidateConfig(1)
	if type(config_settings) != v:t_list
		return
	endif
	let username = config_settings[0]
	let host = config_settings[1]
	let port = config_settings[2]
	let mapping = config_settings[3]
	let SSH_key_path = JB_SFTP_GetSSHKeyPath()
	if filereadable(SSH_key_path)
		echo "SSH-keygen already exists, do you want to regenerate it?"
		echo "  \"" . SSH_key_path . "\""
		let chosenANSWER = input('[ y/n ] > ')
		echo "\n"
		if tolower(chosenANSWER) == "y"
			call delete(SSH_key_path)
			if filereadable(SSH_key_path.".pub")
				call delete(SSH_key_path.".pub")
			endif
		else
			echo "Well then, not doing anything then"
			return
		endif
	endif
	call system("ssh-keygen -q -t rsa -N '' -f ".SSH_key_path." <<<y 2>&1 >/dev/null")
	:bo 10sp
	:term
	:normal A
	call feedkeys("cat ".SSH_key_path.".pub | ssh -p ".port." ".username."@".host." 'cat >> .ssh/authorized_keys';exit")
	call feedkeys("\<CR>")
	return
endfunction

function! JB_SFTP_SSHSendCommand(command)
	let SSH_key_path = JB_SFTP_GetSSHKeyPath()
	let config_settings = JB_SFTP_ValidateConfig(1)
	if type(config_settings) != v:t_list
		return
	endif
	let username = config_settings[0]
	let host = config_settings[1]
	let port = config_settings[2]
	let mapping = config_settings[3]
	let responds = system("ssh -i ". SSH_key_path ." -p ".port." ".username."@".host." \"".a:command."\"")
	return responds
endfunction

function! JB_SFTP_UpdateHashLog()
	let sha256sumDiff = JB_SFTP_CompareSha256Sum()
	if type(sha256sumDiff) != v:t_list
		return
	endif
	let local_hashsum = sha256sumDiff[0]
	let remote_hashsum = sha256sumDiff[1]
	let idea_dir = JB_SFTP_GetIdeaDirPath()
	let hashsum_log_path = idea_dir . "/VIM_JB_SFTP_hashsum.log"
	let hashsum_log = readfile(hashsum_log_path)
	if hashsum_log[-1] == "BUSYFLAG"
		echo "File is in use right now by another instance"
		return
	endif
	call writefile(['BUSYFLAG'], hashsum_log_path, "a")
	let c = 1 " Because it skips first line
	for line in hashsum_log[1:-1]
		if split(line, ', ./')[1] == @%
			let cached_local_hash = split(line, ', ')[0]
			let cached_remote_hash = split(line, ', ')[1]
			let newline = local_hashsum . ", " . remote_hashsum . ", ./" . @%
			if c == 1 && line == newline
				call system("sed -i -e ".(len(hashsum_log)+1)."'d' \"".hashsum_log_path."\"") " Remove BUSYFLAG	
			else
				" Remove line c, insert at line 2, remove BUSYFLAG
				call system("sed -i -e ".(c+1)."'d' \"".hashsum_log_path."\";sed -i -e \"2i".newline."\" \"".hashsum_log_path."\";sed -i -e ".(len(hashsum_log)+1)."'d' \"".hashsum_log_path."\"")
			endif
			if local_hashsum != remote_hashsum
				echo "The file is changed on the server"
				echo "Do you want to download the file?"
				echo "(Current buffer will be discarded)"
				let chosenINPUT = input('( y/n ) > ')
				echo "\n"
				if tolower(chosenINPUT) == "y"
					call JB_SFTP_DownloadFile()
				else
					echo "Well then, not doing anything then"
					return
				endif
			endif
			break
		endif
		let c+=1
	endfor
endfunction

function! JB_SFTP_CompareSha256Sum()
	let config_settings = JB_SFTP_ValidateConfig(1)
	if type(config_settings) != v:t_list
		return
	endif
	let work_dir_path = JB_SFTP_GetWorkDirPath()
	let mapping = config_settings[3]
	let local_hashsum = system("cd ".work_dir_path."; sha256sum ".@%)
	let remote_hashsum = JB_SFTP_SSHSendCommand("cd ".mapping . "; sha256sum ".@%)
	let local_hashsum = split(local_hashsum, ' ')[0]
	let remote_hashsum = split(remote_hashsum, ' ')[0]
	return [local_hashsum, remote_hashsum]
endfunction

function! JB_SFTP_UploadFile()
	let SSH_key_path = JB_SFTP_GetSSHKeyPath()
	let config_settings = JB_SFTP_ValidateConfig(1)
	if type(config_settings) != v:t_list
		return
	endif
	let work_dir_path = JB_SFTP_GetWorkDirPath()
	let username = config_settings[0]
	let host = config_settings[1]
	let port = config_settings[2]
	let mapping = config_settings[3]
	:w
	call system("scp -i ". SSH_key_path ." -P ".port." ".work_dir_path.@%." ".username."@".host.":".mapping .@%)
	call JB_SFTP_UpdateHashLog()
endfunction

function! JB_SFTP_DownloadFile()
	let SSH_key_path = JB_SFTP_GetSSHKeyPath()
	let config_settings = JB_SFTP_ValidateConfig(1)
	if type(config_settings) != v:t_list
		return
	endif
	let work_dir_path = JB_SFTP_GetWorkDirPath()
	let username = config_settings[0]
	let host = config_settings[1]
	let port = config_settings[2]
	let mapping = config_settings[3]
	call system("scp -i ". SSH_key_path ." -P ".port." ".username."@".host.":".mapping .@%. " ".work_dir_path.@%)
	call JB_SFTP_UpdateHashLog()
	:e!
endfunction

function! JB_SFTP_ValidateSSH()
	let config_settings = JB_SFTP_ValidateConfig(1)
	if type(config_settings) != v:t_list
		return
	endif
	let username = config_settings[0]
	let host = config_settings[1]
	let port = config_settings[2]
	let mapping = config_settings[3]
	let SSH_key_path = JB_SFTP_GetSSHKeyPath()
	if !filereadable(SSH_key_path)
		echo "You need to generate SSH-keygen before you can sync"
		call JB_SFTP_GenerateSSHKeyFile()
		return
	endif
	" test the ssh settings
	let responds = system("ssh -i ". SSH_key_path ." -p ".port." ".username."@".host." echo test ping")
	if split(responds, ' ping')[0] == 'test'
		return 1
	else
		echo "Some issue getting contact with the SSH connection"
		echo "Suggesting recreation of SSH key\n"
		call JB_SFTP_GenerateSSHKeyFile()
		return
	endif
endfunction

function! JB_SFTP_SyncAll_sha256sum()
	if JB_SFTP_ValidateSSH() != 1
		echo "Issue validating SSH connectionc"
		return
	endif
	let SSH_key_path = JB_SFTP_GetSSHKeyPath()

	let config_settings = JB_SFTP_ValidateConfig(1)
	let username = config_settings[0]
	let host = config_settings[1]
	let port = config_settings[2]
	let mapping = config_settings[3]

	let hashsum_log_path = JB_SFTP_GetHashSumLogPath()
	if filereadable(hashsum_log_path)
		call delete(hashsum_log_path)
	endif
	call writefile(["local hashsum, remote hashsum, filename"], hashsum_log_path, "a")

	let work_dir_path = JB_SFTP_GetWorkDirPath()
	let randomstring = JB_SFTP_RandomizedString(20)
	let randomstring2 = JB_SFTP_RandomizedString(18)
	call system("cd ".work_dir_path."; find -type f -print0 | xargs -0 sha256sum >> /tmp/JB_SFTP_".randomstring2.".log")
	call system("ssh -i ".SSH_key_path." -p ".port." ".username."@".host." \"cd ".mapping."/;find -type f -print0 | xargs -0 sha256sum\" >> /tmp/JB_SFTP_".randomstring.".log")

	if !filereadable("/tmp/JB_SFTP_".randomstring.".log")
		echo "Unable to save to file /tmp/JB_SFTP_".randomstring.".log, quitting"
		return
	endif

	let hashsum_log = readfile("/tmp/JB_SFTP_".randomstring2.".log")
	let remote_hashsum_log = readfile("/tmp/JB_SFTP_".randomstring.".log")
	let finished_log = []
	let c = 0
	for line in hashsum_log
		if line == ""
			continue
		endif
		let local_filefocus = split(line, ' ./')[1]
		let local_hashsum =  split(line, ' ')[0]
		let wasFound = 0
		for line2 in remote_hashsum_log
			if line2 == ""
				continue
			endif
			let remote_filefocus =  split(line2, ' ./')[1]
			let remote_hashsum =  split(line2, ' ')[0]
			if local_filefocus == remote_filefocus
				call add(finished_log, local_hashsum . ', ' . remote_hashsum . ', ./'.local_filefocus)
				let wasFound = 1
				break
			endif
		endfor
		if wasFound == 0
			call add(finished_log, local_hashsum . ', , ./'.local_filefocus)
		endif
		let c+=1
	endfor
	call writefile(finished_log, hashsum_log_path, "a")
	call delete("/tmp/JB_SFTP_".randomstring2.".log")
	call delete("/tmp/JB_SFTP_".randomstring.".log")
endfunction

function! JB_SFTP_sha256sum_append(filename)
	let hashsum_log_path = JB_SFTP_GetHashSumLogPath()
	if !filereadable(hashsum_log_path)
		call writefile(["local hashsum,remote hashsum,filename"], hashsum_log_path, "a")
	endif
endfunction
