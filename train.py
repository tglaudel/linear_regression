
def train(liste, learningRate):
	n = 100 # nombre d'iteration.
	theta0 = 0.0
	theta1 = 0.0
	tmptheta0 = 0.0
	tmptheta1 = 0.0
	somme = 0.0
	somme2 = 0.0
	m = len(liste)
	for i in range(1, n + 1):
		somme = 0.0
		somme2 = 0.0
		print theta0, theta1
		for element in liste:
			somme += theta0 + theta1 * float(element[0]) - float(element[1])
			somme2 += (theta0 + theta1 * float(element[0]) - float(element[1])) * float(element[0])
		print "somme", somme, "somme2", somme2, "theta0", theta0, "theta1", theta1, "m", float(1 / float(m))
		theta0 -= learningRate * float(1 / float(m)) * somme
		theta1 -= learningRate * float(1 / float(m)) * somme2
		# print theta0, theta1, somme, somme2, m, tmptheta1, tmptheta0
	return theta0, theta1

def parse():
	fichier = open("data2.csv", "r")
	liste = []
	premiere_line = fichier.readline().rstrip('\n')
	for ligne in fichier:
		tab = ligne.rstrip('\n').split(',')
		liste.append([tab[0],tab[1]])
	return liste

liste = parse()
print train(liste, 1)
