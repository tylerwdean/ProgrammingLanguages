const todoButton = document.getElementById("addItem");
const todoInput = document.getElementById("todo");
const emptyList = document.getElementById("emptyList");
let counter = localStorage.getItem("counter") || 0;
let storedData = JSON.parse(localStorage.getItem("storedData")) || [];
storedData.map((item) => addItemToList(item.text, item.counter, item.checked));
checkForEmptyTasks();

todoInput.addEventListener("keydown", (e) => {
    if (e.key === 'Enter') submitToDo(e);
})

todoButton.addEventListener("click", (e) => submitToDo(e))

function submitToDo(e){
        //stop whatever the click would have done
        e.preventDefault();
        console.log("Add item pressed")
    
        //get the input value and add it to the todo list
        const todoItem = todoInput.value;

        if (todoItem.length < 1) return;

        addItemToList(todoItem, counter);
        storedData = [...storedData, { text: todoItem, counter }]
        counter++;
        console.log(todoItem);
    
        //set the input back to nothing
        todoInput.value = "";
        localStorage.setItem("counter", String(counter));
        saveList();
        checkForEmptyTasks();
}

function addItemToList(text, counter, checked = false) {
    console.log("Add item called");
    listDiv = document.getElementById("list");
    const newElement = document.createElement("div");
    newElement.id = "div-" + counter;
    listDiv.appendChild(newElement);

    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.checked = checked;
    checkbox.id = "checkbox-" + counter;
    checkbox.addEventListener("change", () => updateCheckbox(counter))

    const p = document.createElement("label");
    let textNode = document.createTextNode(text + " ");
    p.appendChild(textNode);
    p.id = "p-" + counter;

    const removeButton = document.createElement("button");
    textNode = document.createTextNode("Remove Task");
    removeButton.id = "button-" + counter;
    removeButton.appendChild(textNode);
    removeButton.addEventListener("click", () => removeElement(counter));

    newElement.appendChild(checkbox);
    newElement.appendChild(p);
    newElement.appendChild(removeButton);

    listDiv.appendChild(newElement);
}

function removeElement(counter) {
    console.log("Removing element" + counter);
    document.getElementById("div-" + counter).remove();
    storedData = storedData.filter((item) => item.counter != counter);
    saveList();
    checkForCompletion();
    checkForEmptyTasks();
}

function saveList() {
    localStorage.setItem("storedData", JSON.stringify(storedData));
}

function updateCheckbox(counter) {
    console.log("Checkbox-" + counter + " updated");
    storedData = storedData.map((item) => item.counter == counter ? { ...item, checked: !item.checked } : item);

    checkForCompletion();
    saveList();
}

function checkForCompletion() {
    let allChecked = true;
    for (let i = 0; i < storedData.length; i++) {
        allChecked = allChecked && storedData[i].checked;
    }

    if (allChecked && storedData.length > 0) {
        alert("You finished all your tasks!");
    }
}

function checkForEmptyTasks(){
    console.log(storedData);
    if (storedData.length < 1){
        emptyList.style.visibility = 'visible'; 
        emptyList.style.display = 'block';
    } else {
        emptyList.style.visibility = 'hidden';
        emptyList.style.display = 'none';
    }
}