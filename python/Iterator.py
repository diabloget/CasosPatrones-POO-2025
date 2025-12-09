# Intefaz Iterator
class Iterator:
    def hasNext(self):
        raise NotImplementedError()

    def next(self):
        raise NotImplementedError()

# Clase Iteradora
class IterableStructure:
    def createIterator(self):
        raise NotImplementedError()

#Metodos de array
class StaticArray(IterableStructure):
    def __init__(self, data):
        self.data = data
    
    def createIterator(self):
        return ArrayIterator(self.data)

class ArrayIterator(Iterator):
    def __init__(self, data):
        self.data = data
        self.index = 0

    def hasNext(self):
        return self.index < len(self.data)

    def next(self):
        value = self.data[self.index]
        self.index += 1
        return value

# Metodos de matriz
class Matrix(IterableStructure):
    def __init__(self, matrix):
        self.matrix = matrix

    def createIterator(self):
        return MatrixIterator(self.matrix)

class MatrixIterator(Iterator):
    def __init__(self, matrix):
        self.matrix = matrix
        self.row = 0
        self.column = 0

    def hasNext(self):
        return self.row < len(self.matrix)

    def next(self):
        value = self.matrix[self.row][self.column]

        self.column += 1
        if self.column >= len(self.matrix[self.row]):
            self.column = 0
            self.row += 1

        return value

# Metodos de Arbol
class BinaryTree(IterableStructure):
    class Node:
        def __init__(self, value, left=None, right=None):
            self.value = value
            self.left = left
            self.right = right

    def __init__(self, root=None):
        self.root = root

    def createIterator(self):
        return BinaryTreeIterator(self.root)


class BinaryTreeIterator(Iterator):
    def __init__(self, root):
        self.stack = []
        self.pushLeft(root)

    def pushLeft(self, node):
        while node:
            self.stack.append(node)
            node = node.left

    def hasNext(self):
        return len(self.stack) > 0

    def next(self):
        node = self.stack.pop()
        value = node.value

        if node.right:
            self.pushLeft(node.right)

        return value

# Espacio para nueva estructura

# Metodo de impresión
def printStructure(structure):
    iterator = structure.createIterator()
    while iterator.hasNext():
        print(iterator.next())


# Main
if __name__ == "__main__":

    # 1. Arreglo
    arr = StaticArray([10, 20, 30])
    print("Arreglo:")
    printStructure(arr)

    # 2. Matriz
    mat = Matrix([
        [1, 2],
        [3, 4],
        [5, 6]
    ])
    print("\nMatriz:")
    printStructure(mat)

    # 3. Árbol binario
    tree = BinaryTree(
        BinaryTree.Node(4,
            BinaryTree.Node(2,
                BinaryTree.Node(1),
                BinaryTree.Node(3)
            ),
            BinaryTree.Node(6,
                BinaryTree.Node(5),
                BinaryTree.Node(7)
            )
        )
    )
    print("\nÁrbol binario (in-order):")
    printStructure(tree)