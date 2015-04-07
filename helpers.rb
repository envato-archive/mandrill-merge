
MADJECTIVES = ["Macabre", "Mad", "Magic", "Magnificent", "Majestic", "Marvellous", "Masterful", "Meaty", "Mechanical", "Mechanised", "Mellifluous", "Meretricious", 
  "Meritorious", "Metallic", "Mighty", "Militant", "Minimal", "Modish", "Molten", "Monomorphic", "Mountainous", "Multiparous", "Munificent", "Musical", "Myopic", 
  "Myriad", "Mysterious"]

def madjective
  MADJECTIVES.sample
end

def valid_email?(email)
  /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.match email
end