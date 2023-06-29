$sessions = (query user).USERNAME

query user | select -skip 1 | foreach { logoff ($_ -split "\s+")[-6] }