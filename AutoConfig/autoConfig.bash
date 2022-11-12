#!/usr/bin/env bash
scriptVersion="0.0.1"
source config.conf

touch "autoConfig.txt"
chmod 666 "autoConfig.txt"
exec &> >(tee -a "autoConfig.txt")

log () {
  m_time=`date "+%F %T"`
  echo $m_time" :: AutoConfig :: $scriptVersion :: "$1
}

if [ "$Radarr" == "true" ]; then
  
  log "Configuring Radarr Settings to TRaSH Guides Recommended"

  log "Getting TRaSH Guide Recommended Movie Naming..."
  movieNaming="$(curl -s https://raw.githubusercontent.com/TRaSH-/Guides/master/docs/Radarr/Radarr-recommended-naming-scheme.md | grep "{Movie Clean" | head -n 1)" 
  
  log "Updating Radarr Moving Naming..."
  updateArr=$(curl -s "$RadarrURL/api/v3/config/naming" -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $RadarrApiKey" --data-raw "{
    \"renameMovies\":true,
    \"replaceIllegalCharacters\":true,
    \"colonReplacementFormat\":\"delete\",
    \"standardMovieFormat\":\"$movieNaming\",
    \"movieFolderFormat\":\"{Movie CleanTitle}{ (Release Year)}\",
    \"includeQuality\":false,
    \"replaceSpaces\":false,
    \"id\":1
    }")
      
  log "Complete"
  
  log "Updating Radarr Media Management..."
  updateArr=$(curl -s "$RadarrURL/api/v3/config/mediamanagement" -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $RadarrApiKey" --data-raw "{
    \"autoUnmonitorPreviouslyDownloadedMovies\":false,
    \"recycleBin\":\"$RecycleBinPath\",
    \"recycleBinCleanupDays\":7,
    \"downloadPropersAndRepacks\":\"doNotPrefer\",
    \"createEmptyMovieFolders\":false,
    \"deleteEmptyFolders\":false,
    \"fileDate\":\"release\",
    \"rescanAfterRefresh\":\"always\",
    \"autoRenameFolders\":false,
    \"pathsDefaultStatic\":false,
    \"setPermissionsLinux\":false,
    \"chmodFolder\":\"755\",
    \"chownGroup\":\"\",
    \"skipFreeSpaceCheckWhenImporting\":false,
    \"minimumFreeSpaceWhenImporting\":100,
    \"copyUsingHardlinks\":true,
    \"importExtraFiles\":true,
    \"extraFileExtensions\":\"srt\",
    \"enableMediaInfo\":true,
    \"id\":1
  }")

  log "Complete"
  
  log "Radarr Settings set to TRaSH Guides Recommended"
  log "Perhaps go checkout the Quality Profiles and Custom Formats on the guide now"

else

  log "Radarr autoConfig not configured"

fi

if [ "$Sonarr" == "true" ]; then
  
  log "Configuring Sonarr Settings to TRaSH Guides Recommended"

  log "Getting TRaSH Guide Recommended Sonarr Naming..."
  standardNaming="$(curl -s "https://raw.githubusercontent.com/TRaSH-/Guides/master/docs/Sonarr/Sonarr-recommended-naming-scheme.md" | grep "{Series" | head -n 1)"
  dailyNaming="$(curl -s "https://raw.githubusercontent.com/TRaSH-/Guides/master/docs/Sonarr/Sonarr-recommended-naming-scheme.md" | grep "{Series" | grep "{Air-Date}")"
  animeNaming="$(curl -s "https://raw.githubusercontent.com/TRaSH-/Guides/master/docs/Sonarr/Sonarr-recommended-naming-scheme.md" | grep "{Series" | grep "{absolute")"
  seriesNaming="$(curl -s "https://raw.githubusercontent.com/TRaSH-/Guides/master/docs/Sonarr/Sonarr-recommended-naming-scheme.md" | grep "{Series" | head -n4 | tail -n1)"

  log "Updating Sonarr File Naming..."
  updateArr=$(curl -s "$SonarrUrl" -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $SonarrApiKey" --data-raw "{
	\"renameEpisodes\":true,
	\"replaceIllegalCharacters\":true,
	\"multiEpisodeStyle\":4,
	\"standardEpisodeFormat\":\"$standardNaming\",
	\"dailyEpisodeFormat\":\"$dailyNaming\",
	\"animeEpisodeFormat\":\"$animeNaming\",
	\"seriesFolderFormat\":\"$seriesNaming\",
	\"seasonFolderFormat\":\"Season {season:00}\",
	\"specialsFolderFormat\":\"Season {season:00}\",
	\"includeSeriesTitle\":false,
	\"includeEpisodeTitle\":false,
	\"includeQuality\":false,
	\"replaceSpaces\":true,
	\"separator\":\" - \",
	\"numberStyle\":\"S{season:00}E{episode:00}\",
	\"id\":1
	}")    

  log "Complete"

  log "Updating Sonrr Media Management..."
  updateArr=$(curl -s "$SonarrUrl/api/v3/config/mediamanagement" -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $SonarrApiKey" --data-raw "{
    \"autoUnmonitorPreviouslyDownloadedEpisodes\":false,
    \"recycleBin\":\"$RecycleBinPath\",
    \"recycleBinCleanupDays\":7,
    \"downloadPropersAndRepacks\":\"doNotPrefer\",
    \"createEmptySeriesFolders\":false,
    \"deleteEmptyFolders\":true,
    \"fileDate\":\"localAirDate\",
    \"rescanAfterRefresh\":\"always\",
    \"setPermissionsLinux\":false,
    \"chmodFolder\":\"775\",
    \"chownGroup\":\"\",
    \"episodeTitleRequired\":\"always\",
    \"skipFreeSpaceCheckWhenImporting\":false,
    \"minimumFreeSpaceWhenImporting\":100,
    \"copyUsingHardlinks\":true,
    \"importExtraFiles\":true,
    \"extraFileExtensions\":\"srt\",
    \"enableMediaInfo\":true,
    \"id\":1
  }")

  log "Complete"
  
  log "Sonarr Settings set to TRaSH Guides Recommended"
  log "Perhaps go checkout the Quality and Release Profiles on the guide now"
  
else

  log "Sonarr autoConfig not configured"

fi
exit