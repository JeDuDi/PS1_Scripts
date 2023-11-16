<#

    .PURPOSE
        Returns information about the status of the TPM module and Bitlocker. 
    
    .NOTES
        Created by JeDuDi

#>

(Get-Tpm).TpmPresent
(Get-Tpm).TpmReady
(Get-Tpm).TpmEnabled


(Get-BitLockerVolume -MountPoint "C:").VolumeStatus
(Get-BitLockerVolume -MountPoint "C:").KeyProtector.KeyProtectorType