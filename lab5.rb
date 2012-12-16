require './router'
require 'readline'
print "Input please step: "
step = Readline.readline(" >", true)
router = Router.new(step.to_i)
str = nil
while (str = Readline.readline(" >", true)) != "exit"
  splited = str.split(" ")
  if splited[0] == "break"
    to_break = splited[1]
    puts "#{to_break} broken"
    router.break!(to_break)
  elsif splited.first == "heal"
    to_heal = splited[1]
    puts "#{to_break} healed"
    router.heal!(to_heal)
  elsif splited.first == "route"
    from, to = splited[1..2]
    to_ari = ->(x){ r={}
                    r[:i], r[:j], r[:k], r[:l] = x.each_char.to_a.map(&:to_i) 
                    r 
                  }
    router.one_to_one(to_ari[from], to_ari[to])
    puts "The whole path is:"
    puts router.whole_path
  end
end
