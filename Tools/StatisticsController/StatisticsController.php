<?php

require_once 'JpGraph/jpgraph.php';
require_once 'JpGraph/jpgraph_bar.php';
require_once 'JpGraph/jpgraph_line.php';

class StatisticsController extends Zend_Controller_Action
{
    public function indexAction() {
        $cache = Zend_Cache::factory('Output','File',array(
                    'lifetime' => 86400,
                    'automaticSerialization' => true
                 )
                 ,array('cacheDir' => './cache/')
        );

        if(!($stats = $cache->load('stats'))) {
            $sql = "SELECT
                        *
                    FROM
                        [Statistics]
                    WHERE
                        [Date] > (DATEADD(d, -1, GETDATE()))
                   ";
            $db   = Zend_Registry::get('db');
            $stmt = $db->prepare($sql);
            $stmt->execute();
            $data = $stmt->fetchAll(PDO::FETCH_OBJ);
    
            $stats = array();
            foreach($data as $row) {
                $key = date("H",strtotime($row->Date));
                $stats[$key] = $row->TotalUser;
            }
            $cache->save($stats);
        }

        $view = Zend_Registry::get('view');
        $view->stats = $stats;
        echo $view->render('graphs/players-online.tpl');
    }

    public function classAction() {
        $cache = Zend_Cache::factory('Output','File',array(
                    'lifetime' => 86400,
                    'automaticSerialization' => true
                 )
                 ,array('cacheDir' => './cache/')
        );

        if(!($stats = $cache->load('class_stats'))) {
            $sql = "SELECT
                        [Class],
                        COUNT(*) AS [numClass]
                    FROM
                        [Player]
                    WHERE
                        [Class] IN (0,1,2)
                    GROUP BY
                        [Class]
                   ";
            $db   = Zend_Registry::get('db');
            $stmt = $db->prepare($sql);
            $stmt->execute();
            $stats = $stmt->fetchAll(PDO::FETCH_OBJ);
            $cache->save($stats);
        }

        $view = Zend_Registry::get('view');
        $view->stats = $stats;
        echo $view->render('graphs/class-pie.tpl');
    }
}

?>