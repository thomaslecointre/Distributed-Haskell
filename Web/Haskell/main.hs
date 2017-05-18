
import Text.HandsomeSoup

main :: IO()
main = do
  let doc = fromUrl "http://en.wikipedia.org/wiki/Narwhal"
  print doc
