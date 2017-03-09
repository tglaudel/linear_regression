

def estimatePrice(mileage, theta0, theta1):
	return (theta0 + (theta1 * mileage))


def train(liste, learningRate):
	n = 5 # nombre d'iteration.
	theta0 = 0.
	theta1 = 0.
	tmptheta0 = 0.
	tmptheta1 = 0.
	somme = 0.
	somme2 = 0.
	m = 1 / float(len(liste))
	for i in range(1, n + 1):
		print
		for element in liste:
			somme += estimatePrice(float(element[0]), theta0, theta1) - float(element[1])
			somme2 += (estimatePrice(float(element[0]), theta0, theta1) - float(element[1])) * float(element[0])
		print "somme", somme,"m", m
		print "somme2", somme2,"m", m
		tmptheta0 = learningRate * m * somme
		tmptheta1 = learningRate * m * somme2
		theta0 = tmptheta0
		theta1 = tmptheta1
		print theta0, theta1
	return theta0, theta1

def parse():
    fichier = open("data.csv", "r")
    liste = []
    premiere_line = fichier.readline().rstrip('\n')
    for ligne in fichier:
        tab = ligne.rstrip('\n').split(',')
        liste.append([tab[0],tab[1]])
    return liste

liste = parse()
print train(liste, 0.0000001)
