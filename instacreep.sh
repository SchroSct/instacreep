#!/bin/bash
savepath=""
mapfile -t usernames < <(cat "${savepath}instacreep.txt")
for username in "${usernames[@]}"
do
mkdir -p "${savepath}${username}"
if cd "${savepath}${username}"
then
   ppc=$(curl -c /tmp/curl.cookies -s "https://www.instagram.com/${username}/?hl=en" | grep -m 1 ProfilePageContainer | sed -e 's/.*href="//g' -e 's/".*//g')
   qhash=$(curl -s "https://www.instagram.com${ppc}" -H "Referer: https://www.instagram.com/${username}/?hl=en" -H 'Origin: https://www.instagram.com' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.81 Safari/537.36' -H 'DNT: 1' --compressed | sed -e 's/{/\n/g'| grep "Ut=\"" | sed -e 's/.*Ut="//g' -e 's/".*//g')
   uid=$(curl -s "https://www.instagram.com/${username}/" | grep -i "${username}" | grep "profilePage_" | sed -e 's/.*profilePage_//g' -e 's/".*//g')
   hnp=$(curl -s "https://www.instagram.com/${username}/" | sed -e 's/{/\n/g' | grep -m 1 "end_cursor" |sed -e 's/.*has_next_page"://g' -e 's/,.*//g')
   ecurs=$(curl -s "https://www.instagram.com/${username}/" | sed -e 's/{/\n/g' | grep -m 1 "end_cursor" |sed -e 's/.*end_cursor":"//g' -e 's/".*//g')
   variables=$(urlencode "{\"id\":\"${uid}\",\"first\":9001,\"after\":\"${ecurs}\"}")
   unset posts
   mapfile -t posts < <(curl -s "https://www.instagram.com/${username}/" | grep -i "${username}" | sed -e 's/shortcode":"/\nshortcode":"/g' | grep -i shortcode | sed -e 's/shortcode":"//g' -e 's/".*//g')
   for post in "${posts[@]}"
   do
      unset images
      mapfile -t images < <(curl -s "https://www.instagram.com/p/${post}/" | grep "og:image" | sed -e 's/.*content="//g' -e 's/".*//g' ; curl -s "https://www.instagram.com/p/${post}/?__a=1" | sed -e 's/{/\n/g' | grep "display_url" | sed -e 's/.*display_url":"//g' -e 's/".*//g')
      for imglink in "${images[@]}"
      do
         if [ -e "${imglink/*\/}" ]
         then
            echo "${imglink/*\/} already downloaded."
         else
            wget -c "${imglink}"
         fi
      done
      if curl -s "https://www.instagram.com/p/${post}/?__a=1"| grep -q "GraphVideo"
      then
         vidlink=$(curl -s "https://www.instagram.com/p/${post}/?__a=1"| sed -e 's/.*video_url":"//g' -e 's/".*//g')
            if [ -e "${vidlink/*\/}" ]
            then
               echo "${vidlink/*\/} already downloaded."
            else
               wget -c "${vidlink}"
            fi
      fi
   done
   unset posts
   mapfile -t posts < <(curl -s "https://www.instagram.com/graphql/query/?query_hash=5b0222df65d7f6659c9b82246780caa7&variables=${variables}" -H 'cookie: mid=W7bXdwAEAAHDQC6fMcg87berjZvz; mcd=3; fbm_124024574287414=base_domain=.instagram.com; csrftoken=PluDQqTw4NSAHUBrgNFgJ6GnPUuOm3az; shbid=16312; ds_user_id=1605107755; rur=ATN; sessionid=IGSC3c8ca0f1f0561df96f712397d2a8a74e4f4c060f37ccc806a7178ef5312e9e0d%3ArJcg6RK28kn7NhUzkKgym1f1ucPpQVW5%3A%7B%22_auth_user_id%22%3A1605107755%2C%22_auth_user_backend%22%3A%22accounts.backends.CaseInsensitiveModelBackend%22%2C%22_auth_user_hash%22%3A%22%22%2C%22_platform%22%3A4%2C%22_token_ver%22%3A2%2C%22_token%22%3A%221605107755%3A2ZXz1fgFZmNG2MY9CrgsmIMAH97z9SIO%3Adb94932eceb7e2b5ad9c3873985765b91219ef3185692f2a3f6273150535c3d5%22%2C%22last_refreshed%22%3A1539080118.8475513458%7D; shbts=1539081212.1150901; urlgen="{\"71.38.87.70\": 209\054 \"71.38.74.78\": 209}:1g9pKX:EbfBPrRpK-XZ62rsg1e5jHVtC-k"' -H 'dnt: 1' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.9' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.81 Safari/537.36' -H 'accept: */*' -H "referer: https://www.instagram.com/${username}/?hl=en" -H 'authority: www.instagram.com' -H 'x-requested-with: XMLHttpRequest' -H 'x-instagram-gis: 681add46bc9bfed31ba8a7c54fb5cd50' --compressed | grep -i "${username}" | sed -e 's/shortcode":"/\nshortcode":"/g' | grep -i shortcode | sed -e 's/shortcode":"//g' -e 's/".*//g' )
   for post in "${posts[@]}"
   do

      unset images
      mapfile -t images < <(curl -s "https://www.instagram.com/p/${post}/" | grep "og:image" | sed -e 's/.*content="//g' -e 's/".*//g' ; curl -s "https://www.instagram.com/p/${post}/?__a=1" | sed -e 's/{/\n/g' | grep "display_url" | sed -e 's/.*display_url":"//g' -e 's/".*//g')
      for imglink in "${images[@]}"
      do
         if [ -e "${imglink/*\/}" ]
         then
            echo "${imglink/*\/} already downloaded."
         else
            wget -c "${imglink}"
         fi
      done

      if curl -s "https://www.instagram.com/p/${post}/?__a=1"| grep -q "GraphVideo"
      then
         vidlink=$(curl -s "https://www.instagram.com/p/${post}/?__a=1"| sed -e 's/.*video_url":"//g' -e 's/".*//g')
            if [ -e "${vidlink/*\/}" ]
            then
               echo "${vidlink/*\/} already downloaded."
            else
               wget -c "${vidlink}"
            fi
      fi

   done
fi
done
