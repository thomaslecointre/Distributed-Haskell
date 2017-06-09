module StatisticsSlave where

import Data.List


-- CloudEachEpisode :: Int -> Int -> [(String, Int)] -> CloudEachEpisode
data CloudEachEpisode = CloudEachEpisode { season :: Int, episode :: Int, cloud :: [(String, Int)]}

instance Show CloudEachEpisode where
  show (CloudEachEpisode a b c) = show a ++ ", " ++ show b ++ ", " ++ show c


-- |Returns a String with the season number, the episode number, and a list of pairs ("word", occurrence number)
statisticsSeasonEpisodeText :: (String, Int, Int, String)   -- ^ A tuple like ("N/A",1,1,"a\nb\nb\nc\nc\nc") where each word of the text is on a new line
                            -> String                       -- ^ A String like "1,1,[("a",1),("b",2),("c",3)]"
statisticsSeasonEpisodeText (_, s, e, text) =
    let ws = lines text in
    let ds = nub ws in
    let rs = map (\d -> (d,length (filter (\w -> d==w) ws))) ds in
    show $ CloudEachEpisode {season = s, episode = e, cloud = rs}

-- |Returns a list of String with the season number, the episode number, and a list of pairs ("word", occurrence number)
statisticsEachSeason    :: [(String, Int, Int, String)] -- ^ A list like [("N/A",1,1,"a\nb\nb\nc\nc\nc"),("N/A",1,2,"d\ne\ne")]
                        -> [String]                     -- ^ A list like ["1,1,[("a",1),("b",2),("c",3)]","1,2,[("d",1),("e",2)]"]
statisticsEachSeason [] = []
statisticsEachSeason l  = map statisticsSeasonEpisodeText l

-- |Returns a list of list of String with the season number, the episode number, and a list of pairs ("word", occurrence number)
statisticsEachSlave :: [[(String, Int, Int, String)]]   -- ^ A list like [[("N/A",1,1,"a\nb\nb\nc\nc\nc"),("N/A",1,1,"d\ne\ne")],[("N/A",2,1,"f\ng\ng\nh\nh\nh"),("N/A",2,2,"i\nj\nj")]]
                    -> [[String]]                       -- ^ A list like [["1,1,[("a",1),("b",2),("c",3)]","1,2,[("d",1),("e",2)]"],["2,1,[("f",1),("g",2),("h",3)]","2,2,[("i",1),("j",2)]"]]
statisticsEachSlave [] = []
statisticsEachSlave l  = map statisticsEachSeason l
