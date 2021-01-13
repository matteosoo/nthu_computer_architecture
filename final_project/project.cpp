#include <iostream>
#include <string>
#include <fstream>
#include <math.h> 
using namespace std;

string reference_list[99999];
string hit_miss_list[99999];

int cache_miss(int cache_sets, int associativity, int reference_list_length, int tag_bits, int indexing_bit_count) 
{
    int total_miss_count = 0;
    string cache[cache_sets][associativity];
    bool nru_list[cache_sets][associativity];

    // the initial nru list are 1
    for(int i = 0; i < cache_sets; i++){
    	for(int j = 0; j < associativity; j++){
            nru_list[i][j] = 1;
        }
    }

    for(int i = 1; i < reference_list_length - 1; i++){
        string index;
        string tag;
        
        int bit_position = 0;

        // using tag_bits, reference_list to extract tag
        for(bit_position; bit_position < tag_bits; bit_position++){
            tag += reference_list[i][bit_position];
        }
        
        // using indexing_bit_count, reference_list to extract index
        int range_of_indexing_bit_count = indexing_bit_count + bit_position;
        for(bit_position; bit_position < range_of_indexing_bit_count; bit_position++){
            index += reference_list[i][bit_position];
        }

        // std::cout << endl;
        // std::cout << "tag = " << tag << endl;
        // std::cout << "index = " << index << endl;

        // change the binary index to decimal index
        int index_decimal = std::stoi(index, 0, 2);
        // std::cout << "index decimal = " << index_decimal << endl;

        bool hit = false;
        
        // if cache hit
        for(int way = 0; way < associativity; way++){
            if(cache[index_decimal][way] == tag){
                hit_miss_list[i] = " hit";
                nru_list[index_decimal][way] = 0;
                hit = true;
                break;
            }
        }
        if(hit){
            continue;
        }

        // if cache miss
        hit_miss_list[i] = " miss";
        total_miss_count++;

        for(int way = 0; way < associativity; way++){
            // if '1' found, replace block and set nru-bit to '0'
            if(nru_list[index_decimal][way] == 1){
                nru_list[index_decimal][way] = 0;
                cache[index_decimal][way] = tag;
                break;    
            }
            // reset
            else if(way+1 == associativity && nru_list[index_decimal][way] == 0){
                // set all nru-bits to '1'
                for(int reset_way = 0; reset_way < associativity; reset_way++){
                    nru_list[index_decimal][reset_way] = 1;
                }
                // replace the first block and set the first nru-bit to '0'
                cache[index_decimal][0] = tag;
                nru_list[index_decimal][0] = 0;
            }
        }
    }
 
    return total_miss_count; 
}

int main(int argc, char* argv[]) 
{
    // std::cout << "Getting started.." << std::endl;

    std::string org_file_name = argv[1];
    std::string lst_file_name = argv[2];
    std::string rpt_file_name = argv[3];

    std::fstream file_in;
    std::fstream file_out;

    // read cache.org
    file_in.open(org_file_name.c_str(), std::ios::in);
    string line;
    int data;
    int data_indx = 0;
    int data_list[4] = {0};
    while(file_in >> line >> data){
        data_list[data_indx++] = data;
    }
    file_in.close();

    int address_bits = data_list[0];
    int block_size = data_list[1];
    int cache_sets = data_list[2];
    int associativity = data_list[3];
    int offset_bits = log2(block_size);
    int indexing_bit_count = log2(cache_sets);
    int indexing_bits[64] = {0}; // since the address_bits will not longer than 64
    int tag_bits = address_bits - offset_bits - indexing_bit_count;

    // choose the least significant bits (LSBs) of block address (skipping offset bits) to decide the cache set.
    for(int i = offset_bits, j = 0; j < indexing_bit_count; i++, j++){
         indexing_bits[j] = i;
    }
    // std::cout << "address_bits: " << address_bits << endl;
    // std::cout << "block_size: " << block_size << endl;
    // std::cout << "cache_sets: " << cache_sets << endl;
    // std::cout << "associativity: " << associativity << endl;
    // std::cout << "offset_bits: " << offset_bits << endl;
    // std::cout << "index_bits: " << indexing_bit_count << endl;
    // std::cout << "tag_bits = " << tag_bits << endl;


    // read reference.lst
    file_in.open(lst_file_name.c_str(), std::ios::in);
    int reference_index = 0;
    bool top_line = false;
    while(file_in >> line) {
        reference_list[reference_index] = line;
        if(!top_line){
            file_in >> line;
            reference_list[reference_index] += " " + line;
            top_line = true;
        }
        reference_index++;
    }
    int reference_list_length = reference_index;
    file_in.close();

    // for (int i = 0; i < reference_list_length; i++){
    //     std::cout << "reference_list[" << i << "] " << reference_list[i] << endl;
    // }

    // cache behavior simulation
    int total_miss_count = cache_miss(cache_sets, associativity, reference_list_length, tag_bits, indexing_bit_count);

    // write index.rpt
    file_out.open(rpt_file_name.c_str(), std::ios::out);

    file_out << "Address bits: " << address_bits << endl;
    file_out << "Block size: " << block_size << endl;
    file_out << "Cache sets: " << cache_sets << endl;
    file_out << "Associativity: " << associativity << endl;
    file_out << endl;
    file_out << "Offset bit count: " << offset_bits << endl;
    file_out << "Indexing bit count: " << indexing_bit_count << endl;
    file_out << "Indexing bits:";
    for(int i = indexing_bit_count - 1; i >= 0; i--){
        file_out << " " << indexing_bits[i];
    }
    file_out << endl;
    
    file_out << endl;

    for(int i = 0; i < reference_list_length; i++){
        file_out << reference_list[i] << hit_miss_list[i] << endl;
    }
    file_out << endl;

    file_out << "Total cache miss count: " << total_miss_count << endl;
    file_out.close();
	
	return 0; 
}
