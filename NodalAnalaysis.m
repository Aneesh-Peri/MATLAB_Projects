disp("Welcome to this Circuit Solver!");
disp("Ground is node 0. All other nodes are numbered 1, 2, 3, etc.");
voltage_source = input("How many voltage sources are in this circuit? ");
voltageSources = struct();

for i = 1:voltage_source
    voltageSources(i).voltage = input(sprintf("Enter the voltage of source %d (V): ", i));
    voltageSources(i).positiveNode = input(sprintf("Enter the positive node of source %d: ", i));
    voltageSources(i).negativeNode = input(sprintf("Enter the negative node of source %d: ", i));
end

resis_count = input("How many resistors do you have in this circuit? ");
resistors = struct();

for j = 1:resis_count
    resistors(j).resistance = input(sprintf("Enter the resistance of resistor %d (Ohms): ", j));
    resistors(j).node1 = input(sprintf("Enter node 1 of resistor %d: ", j));
    resistors(j).node2 = input(sprintf("Enter node 2 of resistor %d: ", j));
end

nodes=[];

for i = 1: voltage_source
    nodes = [nodes,voltageSources(i).positiveNode, voltageSources(i).negativeNode];
end
for j = 1:resis_count
    nodes = [nodes, resistors(j).node1, resistors(j).node2];
end
nodes = unique(nodes);
nodes(nodes == 0) = [];
numNodes = length(nodes);
disp("Nodes identified:");
disp(nodes);
numSources=voltage_source;
A=zeros(numNodes + numSources);
b = zeros(numNodes +numSources,1);

for j = 1:resis_count
    R=resistors(j).resistance;
    g=1/R;

    n1=find(nodes==resistors(j).node1,1);
    n2=find(nodes==resistors(j).node2,1);
    if ~isempty(n1)
        A(n1,n1) = A(n1,n1) + g;
    end

    if ~isempty(n2)
        A(n2,n2) = A(n2,n2) + g;
    end

    if ~isempty(n1) && ~isempty(n2)
        A(n1,n2) = A(n1,n2) - g;
        A(n2,n1) = A(n2,n1) - g;
    end

end

for i = 1:voltage_source

    p = find(nodes == voltageSources(i).positiveNode, 1);
    n = find(nodes == voltageSources(i).negativeNode, 1);

    sourceIndex = numNodes + i;

    if ~isempty(p)
        A(p,sourceIndex) = A(p,sourceIndex) + 1;
        A(sourceIndex,p) = A(sourceIndex,p) + 1;
    end

    if ~isempty(n)
        A(n,sourceIndex) = A(n,sourceIndex) - 1;
        A(sourceIndex,n) = A(sourceIndex,n) - 1;
    end

    b(sourceIndex) = voltageSources(i).voltage;

end
x = A\b;
nodeVoltages = x(1:numNodes);
sourceCurrents = x(numNodes+1:end);


disp("========== NODE VOLTAGES ==========");

fprintf("Node 0: 0 V\n");

for i = 1:numNodes
    fprintf("Node %d: %.4f V\n", nodes(i), nodeVoltages(i));
end

disp("========== VOLTAGE SOURCE CURRENTS ==========");

for i = 1:voltage_source
    fprintf("Source %d current: %.4f A\n", i, sourceCurrents(i));
end