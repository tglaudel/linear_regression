

def parse():
    fichier = open("data.csv", "r")
    liste = []
    premiere_line = fichier.readline().rstrip('\n')
    for ligne in fichier:
        tab = ligne.rstrip('\n').split(',')
        liste.append([tab[0],tab[1]])
    return liste

print parse()
