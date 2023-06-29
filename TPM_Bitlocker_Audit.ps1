

(Get-Tpm).TpmPresent
(Get-Tpm).TpmReady
(Get-Tpm).TpmEnabled


(Get-BitLockerVolume -MountPoint "C:").VolumeStatus
(Get-BitLockerVolume -MountPoint "C:").KeyProtector.KeyProtectorType