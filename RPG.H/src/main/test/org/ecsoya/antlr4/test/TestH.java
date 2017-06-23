package org.ecsoya.antlr4.test;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CodePointCharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.ecsoya.antlr4.RPGHLexer;
import org.ecsoya.antlr4.RPGHParser;

public class TestH {

	public static void main(String[] args) {
		CodePointCharStream input = CharStreams.fromString("");
		RPGHLexer lexer = new RPGHLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		RPGHParser parser = new RPGHParser(tokens);
		ParseTree tree = parser.r();
		System.out.println(tree.toStringTree(parser));
	}

}
